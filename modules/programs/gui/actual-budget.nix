{
  config.flake.factory.actual-budget = tailscale-domain:
    {pkgs,...}:{
      users = {
        users.actual = {
          isSystemUser = true;
          group = "actual";
          extraGroups = [ "tailscale" ];
        };
        groups.actual = { };
      };

      services.actual = {
        enable = true;
        openFirewall = false;
        user = "actual";
        group = "actual";

        settings = {
          port = 5006;
          hostname = tailscale-domain;
          https = {
            key = "/var/lib/actual-certs/${tailscale-domain}.key";
            cert = "/var/lib/actual-certs/${tailscale-domain}.crt";
          };
        };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 5006 ];

      # Certs live outside actual's StateDirectory: systemd keeps that one at
      # 0700 and the service can't always traverse it.
      systemd.tmpfiles.rules = [
        "d /var/lib/actual-certs 0750 actual actual - -"
      ];

      # systemd creates actual's StateDirectory; hand it back to `actual` so
      # the service can read/write its data.
      systemd.services.actual-state-ownership = {
        description = "Ensure Actual's state directory belongs to the actual user";
        before = [ "actual.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "fix-actual-state-ownership" ''
            ${pkgs.coreutils}/bin/chown -R actual:actual /var/lib/actual
            ${pkgs.coreutils}/bin/chmod 0700 /var/lib/actual
          '';
        };
      };

      # Actual binds to the MagicDNS name, so it must resolve before startup.
      systemd.services.actual-wait-dns = {
        description = "Wait for ${tailscale-domain} to resolve";
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "wait-actual-dns" ''
            for _ in $(seq 1 60); do
              if ${pkgs.getent}/bin/getent hosts ${tailscale-domain} >/dev/null 2>&1; then
                exit 0
              fi
              sleep 1
            done
            echo "WARNING: ${tailscale-domain} did not resolve, starting Actual anyway" >&2
          '';
        };
      };

      # Renews the ACME cert (90 days) and copies it where actual reads it.
      # `tailscale cert` reuses tailscaled's cached cert while it is valid, so
      # calling it daily doesn't burn Let's Encrypt's duplicate rate limit.
      # Runs as root: /var/lib/tailscale/certs is 0700 root:root.
      systemd.services.tailscale-certs-sync = {
        description = "Renew and sync Tailscale certs for Actual";
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "sync-tailscale-certs" ''
            set -euo pipefail

            domain=${tailscale-domain}
            src_crt=/var/lib/tailscale/certs/$domain.crt
            src_key=/var/lib/tailscale/certs/$domain.key
            dst=/var/lib/actual-certs

            ${pkgs.coreutils}/bin/install -d -m 0750 -o actual -g actual "$dst"

            # Renew if missing or expiring within 30 days.
            # --cert-file/--key-file are explicit: without them the pair lands
            # in the current directory.
            if [ ! -f "$src_crt" ] || ! ${pkgs.openssl}/bin/openssl x509 -checkend $(( 30 * 24 * 3600 )) -noout -in "$src_crt" >/dev/null 2>&1; then
              echo "Renewing Tailscale certificate for $domain..."
              if ! ${pkgs.coreutils}/bin/timeout 120 ${pkgs.tailscale}/bin/tailscale cert \
                   --cert-file "$src_crt" --key-file "$src_key" "$domain"; then
                echo "WARNING: could not renew the certificate for $domain" >&2
              fi
            fi

            if [ ! -f "$src_crt" ] || [ ! -f "$src_key" ]; then
              echo "ERROR: no Tailscale certificate available at $src_crt" >&2
              exit 1
            fi

            # cert and key must match, or https.createServer() rejects them.
            cert_pub=$(${pkgs.openssl}/bin/openssl x509 -noout -pubkey -in "$src_crt" | ${pkgs.coreutils}/bin/sha256sum)
            key_pub=$(${pkgs.openssl}/bin/openssl pkey -pubout -in "$src_key" | ${pkgs.coreutils}/bin/sha256sum)
            if [ "$cert_pub" != "$key_pub" ]; then
              echo "ERROR: certificate and key for $domain do not match" >&2
              exit 1
            fi

            # Copy and restart only if the cert changed.
            if ! ${pkgs.diffutils}/bin/cmp -s "$src_crt" "$dst/$domain.crt" || ! ${pkgs.diffutils}/bin/cmp -s "$src_key" "$dst/$domain.key"; then
              ${pkgs.coreutils}/bin/install -m 0644 -o actual -g actual "$src_crt" "$dst/"
              ${pkgs.coreutils}/bin/install -m 0640 -o actual -g actual "$src_key" "$dst/"
              # restart, not try-restart: the latter does nothing while the
              # unit is inactive (e.g. crash-looping).
              systemctl --no-block restart actual
            fi
          '';
        };
      };

      systemd.timers.tailscale-certs-sync = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          RandomizedDelaySec = "1h";
          Persistent = true;
        };
      };

      # Pick up a cert renewed by something else.
      systemd.paths.tailscale-certs-sync = {
        pathConfig = {
          PathChanged = "/var/lib/tailscale/certs/${tailscale-domain}.crt";
          Unit = "tailscale-certs-sync.service";
        };
        wantedBy = [ "multi-user.target" ];
      };

      systemd.services.actual = {
        after = [
          "network-online.target"
          "tailscaled.service"
          "tailscale-certs-sync.service"
          "actual-state-ownership.service"
          "actual-wait-dns.service"
        ];
        wants = [
          "network-online.target"
          "tailscaled.service"
          "tailscale-certs-sync.service"
          "actual-state-ownership.service"
          "actual-wait-dns.service"
        ];
        serviceConfig = {
          RestartSec = "5s";
          # actual-server 26.11 swallows the error and exits 0; not restarting
          # on a clean exit turns the crash loop into a visible failed unit.
          RestartPreventExitStatus = [ 0 ];
        };
        # Log why actual-server died instead of just "Unhandled rejection".
        environment.DEBUG = "actual-sensitive:server";
      };
    };
}
