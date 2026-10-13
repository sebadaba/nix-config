---
name: nixos-search
description: Load this skill whenever you need the canonical nixpkgs attribute name for a package, the exact dotted path / type / default of a NixOS, Home Manager, or nix-darwin option, or to verify that a package or option path exists in nixos-unstable. Triggers on user phrases like "search nixos", "search nixpkgs", "search.nixos.org", "is there a package for X", "what's the option for Y", "is programs.zsh.enable the right path", "find the option that controls Z", "existe el paquete X", "busca la opción Y", "cuál es el attr name de X", and ALSO on internal prompts where you are about to write `pkgs.<attr>` or `<option.path>` and are not 100% sure of the spelling. Pinned to the nixos-unstable channel to match this repo. Do NOT use for general web search, Nix language syntax, or for code review — for those prefer context7 or the Nix manual.
---

# nixos-search

Look up the canonical **attribute name** of a nixpkgs package or the **dotted
path / type / default** of a NixOS, Home Manager, or nix-darwin option by
querying the search.nixos.org Elasticsearch backend.

The repo pins to `nixos-unstable`; this skill queries the latest
`nixos-*-unstable` index, so results track what the user will actually get
when they `nix build` or `nixos-rebuild switch`.

## How to invoke

Run the helper script directly. The agent MUST use this script instead of
hand-rolling curl — it owns auth, index discovery, query shape, and the ES
→ flat-JSON projection.

```bash
SCRIPT=.opencode/skill/nixos-search/scripts/nixos-search.sh
```

| Subcommand | When to use |
| --- | --- |
| `packages <query>` | Fuzzy prefix search across `package_attr_name`, `package_pname`, and `package_description`. Use when you know roughly what you're looking for but not the exact attr. |
| `package <attr>` | Exact attribute-name lookup. Use when the user names a package (or you want to confirm a guess). Returns up to 5 matches. |
| `options <query> [--src nixos\|home-manager\|darwin\|all]` | Prefix search over option paths and descriptions. Default `--src nixos`. **Always pass `--src`** when searching paths that exist in both NixOS and Home Manager (e.g. `programs.git.*`, `services.*`, `home.*`). |
| `option <path>` | Exact dotted-path lookup. Use when the user names an option path and you need its type, default, or module source. |
| `latest-index` | Print the index name currently being queried. Use for debugging or to show the user how fresh the data is. |
| `help` | Show usage. |

Output is **NDJSON** (one JSON object per line) so the agent can pipe
through `jq` or `grep` directly. The script's exit code is `0` on hits,
`1` on usage error, `2` on network/auth failure, and `3` on no hits — treat
`3` as "package/option does not exist" rather than an error.

## Response fields

**Packages** (`packages`, `package`):

| Field | Meaning |
| --- | --- |
| `attr_name` | The `pkgs.<attr_name>` to use. **This is what goes in `environment.systemPackages` / `home.packages` / `services.x.package`.** |
| `pname` | The package's name (may differ from `attr_name` for forks, e.g. `firefox-esr` has `pname=firefox`). |
| `version` | Pinned version, or `null` if it follows `nixpkgs`. |
| `description` | One-line description from the package's `meta.description`. |
| `homepage` | `meta.homepage` (array, sometimes). |
| `programs` | Binaries the package installs into `$PATH`. Cross-check this if the user is enabling a service vs. a CLI tool. |
| `license` | SPDX IDs from `meta.license`. |
| `_score` | ES relevance score (useful for sorting ties, otherwise ignore). |

**Options** (`options`, `option`):

| Field | Meaning |
| --- | --- |
| `option_name` | The full dotted path. **This is what goes in `services.foo = { ... }`.** |
| `type` | NixOS type signature (e.g. `boolean`, `list of (submodule)`, `null or package`). |
| `default` | Rendered default value. Useful for sanity-checking (`pkgs.git`, `false`, etc.). |
| `description` | HTML-stripped, 200-char-truncated description. |
| `source` | The module file declaring the option. **Cross-check this to disambiguate NixOS vs Home Manager** — e.g. `nixos/modules/services/web-servers/nginx/default.nix` (NixOS) vs `modules/programs/git.nix` (Home Manager) vs `nixos/modules/programs/git.nix` (NixOS `programs.git`). |
| `_score` | Ignore. |

## Decision rules

1. **If the user names a package** ("install X", "qué paquete es Y"),
   prefer `package <attr>` for confirmation and `packages <query>` to find
   related/alternative packages. Always return `attr_name`, never `pname`.

2. **If the user names an option path** ("is `services.nginx.virtualHosts`
   valid?", "qué tipo tiene `programs.zsh.shellAliases`?"), use
   `option <path>` to get the authoritative type and default. Do not guess.

3. **If the user asks an open question** ("how do I enable X in NixOS?",
   "qué opciones hay para `services.openssh`?"), use `options` with
   `--src` set to the relevant source. The default `--src nixos` is wrong
   for anything managed by Home Manager.

4. **When the same path exists in both NixOS and Home Manager** (common:
   `programs.git.*`, `programs.zsh.*`, `services.*`, `home.*`), use
   `--src` explicitly and cross-check the `source` field. NixOS
   `programs.<x>` modules are bare-bones system-level toggles; Home
   Manager's are user-level. Mixing them up is a frequent bug source.

5. **After finding the answer, propose the exact `*.nix` snippet** the user
   would write — this is what they actually came for. Use the style
   already present in this repo (flake-parts attrset, `pkgs.<attr_name>`,
   option path verbatim).

6. **If the helper exits with code 3 (no hits)**, say so plainly — the
   package or option genuinely doesn't exist (or was renamed). Do not
   propose a guess.

## Worked examples

User: "Quiero un cliente de correo en terminal, ¿qué hay en nixpkgs?"
```bash
SCRIPT=.opencode/skill/nixos-search/scripts/nixos-search.sh
$SCRIPT packages "terminal mail"
```

User: "¿Cuál es el paquete de ffmpeg con soporte para vaapi?"
```bash
$SCRIPT packages ffmpeg
# look for variants, or follow up with:
$SCRIPT packages "ffmpeg vaapi"
```

User: "¿Cómo configuro sshd en este host?"
```bash
$SCRIPT options services.openssh --src nixos
$SCRIPT option services.openssh.enable        # confirm exact path
```

User: "Necesito que git use mi delta y mi user.email"
```bash
$SCRIPT options programs.git --src home-manager
$SCRIPT option programs.git.settings         # the central config block
```

## Operational notes

- **Auth**: Credentials are fetched on first run from search.nixos.org's
  public JS bundle (Bonsai's basic-auth, exposed in the static JS bundle —
  not a secret, anyone with DevTools can see them). The script writes them
  to `.credentials` next to itself (mode 0600) and reuses them on
  subsequent runs. A stale cache (HTTP 401) is auto-refreshed once. Force
  specific values by setting both `NIXOS_SEARCH_USER` and
  `NIXOS_SEARCH_PASS` env vars; clear the cache with `rm
  .opencode/skill/nixos-search/scripts/.credentials`. The cache file is
  gitignored.

- **Index discovery**: the script picks the most recent
  `nixos-<N>-unstable-<hash>` index by creation date, so it tracks
  `nixpkgs` reindexes without a hard-coded hash. If the API returns
  `index_not_found_exception`, just re-run.

- **Dependency**: `jq` is required. The script falls back to
  `nix shell nixpkgs#jq -- jq ...` if `jq` is not on `PATH`, which is
  slow per call but lets it work in a fresh `nix develop` shell. For
  best performance, add `nixpkgs#jq` to the user's persistent dev shell.

- **Rate limits**: None observed in normal use, but the helper caps each
  query at 10–15 hits. Re-run with a more specific query if the user
  needs more.
