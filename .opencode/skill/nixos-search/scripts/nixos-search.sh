#!/usr/bin/env bash
# nixos-search.sh — helper for the `nixos-search` opencode skill.
#
# Wraps the search.nixos.org Elasticsearch backend (Bonsai-hosted) so the
# agent does not have to remember auth, index names, or field mappings.
#
# Subcommands:
#   packages <query>                Search nixpkgs packages by name/description (prefix match).
#   package  <attr>                 Exact lookup by attribute name (e.g. ripgrep).
#   option   <path>                 Exact lookup by dotted option path (e.g. services.nginx.enable).
#   options  <query> [--src nixos|home-manager|darwin|all]
#                                   Prefix search over option names + descriptions.
#   latest-index                    Print the most recent nixos-*-unstable index name.
#   help                            Show usage.
#
# Output: newline-delimited JSON of hits (jq-friendly). Each line has:
#   attr_name / option_name, version (pkg), type, description (truncated to 200 chars),
#   source (option), _score.
#
# Exit codes: 0 ok, 1 usage error, 2 network/auth error, 3 no hits.
#
# Credentials: fetched on first run from search.nixos.org's public JS bundle
# and cached to .credentials next to this script (mode 0600). Env vars
# NIXOS_SEARCH_USER and NIXOS_SEARCH_PASS (both, or neither) override the
# cache. A stale cache (HTTP 401) is auto-refreshed once.

set -euo pipefail

# --- Paths --------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CRED_FILE="$SCRIPT_DIR/.credentials"

# --- Public endpoint configuration --------------------------------------------
: "${NIXOS_SEARCH_URL:=https://search.nixos.org/backend}"
DESC_LIMIT=200

# --- jq bootstrap -------------------------------------------------------------
# In Nix dev environments, fall back to `nix shell nixpkgs#jq` if jq is not
# on PATH. Slow per call but keeps the script self-contained.
if ! command -v jq >/dev/null 2>&1; then
  if command -v nix >/dev/null 2>&1; then
    jq() { nix --quiet shell 'nixpkgs#jq' --command jq "$@"; }
  else
    echo "nixos-search.sh: 'jq' is required (install via 'nix profile install nixpkgs#jq' or your package manager)" >&2
    exit 1
  fi
fi

# --- Credentials --------------------------------------------------------------
# search.nixos.org exposes the basic-auth credentials for its Bonsai-hosted
# Elasticsearch cluster in its public JS bundle — not a secret, anyone with
# DevTools can see them. We fetch them on first run, persist to CRED_FILE,
# and reuse on subsequent runs. Env vars override the cache.
NIXOS_SEARCH_USER="${NIXOS_SEARCH_USER:-}"
NIXOS_SEARCH_PASS="${NIXOS_SEARCH_PASS:-}"

# Persist fetched credentials to CRED_FILE atomically (mode 0600).
# Args: user pass
write_cred_file() {
  local tmp
  tmp=$(mktemp "${CRED_FILE}.tmp.XXXXXX") || return 1
  if ! jq -n --arg u "$1" --arg p "$2" '{user:$u, pass:$p}' > "$tmp" 2>/dev/null; then
    rm -f "$tmp"
    return 1
  fi
  chmod 600 "$tmp"
  mv "$tmp" "$CRED_FILE"
}

# Fetch fresh credentials from the search.nixos.org JS bundle. Sets the
# NIXOS_SEARCH_USER and NIXOS_SEARCH_PASS globals and persists them.
fetch_creds_from_bundle() {
  local html bundle js user pass
  html=$(curl -fsS --max-time 15 "https://search.nixos.org/" 2>/dev/null) || {
    echo "nixos-search.sh: could not download search.nixos.org HTML" >&2
    return 1
  }
  bundle=$(grep -oE 'src="/static/js/index\.[a-f0-9]+\.js"' <<<"$html" \
           | head -1 | sed 's|^src="||;s|"$||')
  [[ -z "$bundle" ]] && {
    echo "nixos-search.sh: could not find JS bundle URL in HTML" >&2
    return 1
  }
  js=$(curl -fsS --max-time 15 "https://search.nixos.org$bundle" 2>/dev/null) || {
    echo "nixos-search.sh: could not download bundle $bundle" >&2
    return 1
  }
  user=$(grep -oE 'elasticsearchUsername:"[^"]+"' <<<"$js" \
         | head -1 | sed 's|elasticsearchUsername:"||;s|"$||')
  pass=$(grep -oE 'elasticsearchPassword:"[^"]+"' <<<"$js" \
         | head -1 | sed 's|elasticsearchPassword:"||;s|"$||')
  if [[ -z "$user" || -z "$pass" ]]; then
    echo "nixos-search.sh: credentials not found in bundle (site may have changed auth strategy)" >&2
    return 1
  fi
  if ! write_cred_file "$user" "$pass"; then
    echo "nixos-search.sh: could not write $CRED_FILE" >&2
    return 1
  fi
  NIXOS_SEARCH_USER="$user"
  NIXOS_SEARCH_PASS="$pass"
}

# Resolve credentials: env vars > cache file > fetch from bundle.
load_creds() {
  # Env override: require both vars or neither (partial override is a mistake).
  if [[ -n "${NIXOS_SEARCH_USER}${NIXOS_SEARCH_PASS}" ]]; then
    if [[ -z "${NIXOS_SEARCH_USER}" || -z "${NIXOS_SEARCH_PASS}" ]]; then
      echo "nixos-search.sh: set both NIXOS_SEARCH_USER and NIXOS_SEARCH_PASS, or neither" >&2
      exit 1
    fi
    return 0
  fi
  # Try cache.
  if [[ -r "$CRED_FILE" ]]; then
    local u p
    u=$(jq -r '.user // empty' "$CRED_FILE" 2>/dev/null || true)
    p=$(jq -r '.pass // empty' "$CRED_FILE" 2>/dev/null || true)
    if [[ -n "$u" && -n "$p" ]]; then
      NIXOS_SEARCH_USER="$u"
      NIXOS_SEARCH_PASS="$p"
      return 0
    fi
  fi
  # Fall back to fetching from the bundle.
  fetch_creds_from_bundle
}

# curl wrapper that retries once on HTTP 401 by refreshing credentials.
# Args: same as curl. Prints response body to stdout. Returns 0 on HTTP 200,
# 1 on auth failure (after refresh), or curl's exit code on network error.
curl_with_auth_retry() {
  local http_file body_file code try
  http_file=$(mktemp); body_file=$(mktemp)
  # shellcheck disable=SC2064  # capture NOW so cleanup sees the right path
  trap "rm -f '$http_file' '$body_file'" RETURN

  for try in 1 2; do
    if ! curl -sS --max-time 30 -o "$body_file" -w '%{http_code}' \
                -u "${NIXOS_SEARCH_USER}:${NIXOS_SEARCH_PASS}" \
                "$@" > "$http_file"; then
      return $?  # network/transport error
    fi
    code=$(<"$http_file")
    case "$code" in
      200) cat "$body_file"; return 0 ;;
      401)
        if [[ "$try" -eq 1 ]]; then
          rm -f "$CRED_FILE"
          if fetch_creds_from_bundle; then continue; fi
        fi
        echo "nixos-search.sh: HTTP 401 authentication failed" >&2
        return 1
        ;;
      *) echo "nixos-search.sh: HTTP $code" >&2; return 1 ;;
    esac
  done
  return 1  # unreachable in practice
}

load_creds

# --- API helpers --------------------------------------------------------------
# Discover the latest nixos-*-unstable index at runtime so we don't bake a
# hash into the script (indices rotate on every reindex). We sort by
# creation date because two indices can share the same nixos-<N>-unstable-
# prefix (the older one is kept around briefly during the rollover).
latest_index() {
  local resp
  if ! resp=$(curl_with_auth_retry "${NIXOS_SEARCH_URL}/_cat/indices?h=index,creation.date.string&format=json"); then
    echo "latest_index: failed to list indices" >&2
    return 1
  fi
  jq -r '[.[] | select(.index | test("^nixos-[0-9]+-unstable-"))]
         | max_by(.["creation.date.string"]).index' <<<"$resp"
}

# Emit the JSON envelope of a search. Args: index, body
do_search() {
  local idx="$1" body="$2"
  curl_with_auth_retry -H "Content-Type: application/json" \
    -d "$body" "${NIXOS_SEARCH_URL}/${idx}/_search"
}

# Project the noisy ES response into the agent-friendly NDJSON shape.
# Args: response_kind (pkg|opt), es_json
project() {
  local kind="$1" es_json="$2"
  case "$kind" in
    pkg)
      jq -c --argjson lim "$DESC_LIMIT" '
        .hits.hits[]? | {
          attr_name:    ._source.package_attr_name,
          pname:        ._source.package_pname,
          version:      ._source.package_version,
          description:  (._source.package_description // "" | .[0:$lim]),
          homepage:     ._source.package_homepage,
          programs:     ._source.package_programs,
          license:      ._source.package_license,
          _score:       ._score
        }' <<<"$es_json"
      ;;
    opt)
      jq -c --argjson lim "$DESC_LIMIT" '
        .hits.hits[]? | {
          option_name:  ._source.option_name,
          type:         ._source.option_type,
          default:      ._source.option_default,
          description:  ((._source.option_description // "") | gsub("<[^>]+>"; "") | .[0:$lim]),
          source:       ._source.option_source,
          _score:       ._score
        }' <<<"$es_json"
      ;;
  esac
}

usage() {
  cat <<EOF
Usage: nixos-search.sh <subcommand> [args]

Subcommands:
  packages <query>                Search packages by name/description (prefix).
  package  <attr>                 Exact lookup by attribute name.
  options  <query> [--src SRC]    Prefix search over option paths. SRC: nixos|home-manager|darwin|all (default: nixos).
  option   <path>                 Exact lookup by dotted option path.
  latest-index                    Print current nixos-*-unstable index.
  help                            This message.

Examples:
  nixos-search.sh packages firefox
  nixos-search.sh package ripgrep
  nixos-search.sh option services.nginx.enable
  nixos-search.sh options programs.git --src home-manager

Environment:
  NIXOS_SEARCH_USER, NIXOS_SEARCH_PASS  Override cached credentials (set both or neither).
  NIXOS_SEARCH_URL                      Override endpoint (default: https://search.nixos.org/backend).
EOF
}

# --- Subcommand handlers ------------------------------------------------------
cmd_packages() {
  local query="$*"
  [[ -z "$query" ]] && { echo "packages: query required" >&2; exit 1; }
  local idx body resp total
  if ! idx=$(latest_index); then exit 2; fi
  body=$(jq -n --arg q "$query" '{
    size: 10,
    _source: ["package_attr_name","package_pname","package_version","package_description","package_homepage","package_programs","package_license"],
    query: {
      multi_match: {
        query: $q,
        fields: ["package_attr_name.edge^3","package_pname.edge^2","package_description"],
        type: "phrase_prefix"
      }
    }
  }')
  if ! resp=$(do_search "$idx" "$body"); then
    echo "packages: search request failed" >&2
    exit 2
  fi
  total=$(jq '.hits.total.value // 0' <<<"$resp")
  if [[ "$total" -eq 0 ]]; then
    echo "no packages matched '$query'" >&2
    exit 3
  fi
  project pkg "$resp"
}

cmd_package() {
  local attr="$*"
  [[ -z "$attr" ]] && { echo "package: attribute name required" >&2; exit 1; }
  local idx body resp total
  if ! idx=$(latest_index); then exit 2; fi
  body=$(jq -n --arg a "$attr" '{
    size: 5,
    _source: ["package_attr_name","package_pname","package_version","package_description","package_homepage","package_programs","package_license"],
    query: { bool: { must: [
      { term: { type: "package" } },
      { term: { package_attr_name: $a } }
    ] } }
  }')
  if ! resp=$(do_search "$idx" "$body"); then
    echo "package: search request failed" >&2
    exit 2
  fi
  total=$(jq '.hits.total.value // 0' <<<"$resp")
  if [[ "$total" -eq 0 ]]; then
    echo "no package named '$attr'" >&2
    exit 3
  fi
  project pkg "$resp"
}

cmd_options() {
  local query="" src="nixos"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --src) src="$2"; shift 2 ;;
      --src=*) src="${1#*=}"; shift ;;
      *) query="${query:+$query }$1"; shift ;;
    esac
  done
  [[ -z "$query" ]] && { echo "options: query required" >&2; exit 1; }

  local type_filter
  case "$src" in
    nixos)          type_filter='{ "term": { "type": "option" } }' ;;
    home-manager)   type_filter='{ "term": { "type": "home-manager-option" } }' ;;
    darwin)         type_filter='{ "term": { "type": "darwin-option" } }' ;;
    all)            type_filter='{ "terms": { "type": ["option","home-manager-option","darwin-option"] } }' ;;
    *) echo "options: --src must be nixos|home-manager|darwin|all" >&2; exit 1 ;;
  esac

  local idx body resp total
  if ! idx=$(latest_index); then exit 2; fi
  body=$(jq -n --arg q "$query" --argjson tf "$type_filter" '{
    size: 15,
    _source: ["option_name","option_type","option_default","option_description","option_source"],
    query: { bool: { must: [
      $tf,
      { multi_match: {
          query: $q,
          fields: ["option_name.edge^3","option_description"],
          type: "phrase_prefix"
      } }
    ] } },
    collapse: { field: "option_name" },
    sort: [{ _score: "desc" }, { option_name: "asc" }]
  }')
  if ! resp=$(do_search "$idx" "$body"); then
    echo "options: search request failed" >&2
    exit 2
  fi
  total=$(jq '.hits.total.value // 0' <<<"$resp")
  if [[ "$total" -eq 0 ]]; then
    echo "no options matched '$query' (src=$src)" >&2
    exit 3
  fi
  project opt "$resp"
}

cmd_option() {
  local path="$*"
  [[ -z "$path" ]] && { echo "option: dotted path required (e.g. services.nginx.enable)" >&2; exit 1; }
  local idx body resp total
  if ! idx=$(latest_index); then exit 2; fi
  body=$(jq -n --arg p "$path" '{
    size: 10,
    _source: ["option_name","option_type","option_default","option_description","option_source"],
    query: { bool: { must: [
      { terms: { type: ["option","home-manager-option","darwin-option"] } },
      { term: { option_name: $p } }
    ] } }
  }')
  if ! resp=$(do_search "$idx" "$body"); then
    echo "option: search request failed" >&2
    exit 2
  fi
  total=$(jq '.hits.total.value // 0' <<<"$resp")
  if [[ "$total" -eq 0 ]]; then
    echo "no option named '$path'" >&2
    exit 3
  fi
  project opt "$resp"
}

# --- Dispatch -----------------------------------------------------------------
sub="${1:-help}"
shift || true
case "$sub" in
  packages)  cmd_packages "$@" ;;
  package)   cmd_package "$@" ;;
  options)   cmd_options "$@" ;;
  option)    cmd_option "$@" ;;
  latest-index) latest_index ;;
  help|--help|-h) usage ;;
  *) usage; exit 1 ;;
esac
