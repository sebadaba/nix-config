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
            key = "/var/lib/actual/certs/${tailscale-domain}.key";
            cert = "/var/lib/actual/certs/${tailscale-domain}.crt";
          };
        };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 5006 ];

      systemd.services.tailscale-certs-sync = {
        description = "Sync Tailscale certs to Actual server-files";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "sync-tailscale-certs" ''
            src_crt=/var/lib/tailscale/certs/${tailscale-domain}.crt
            src_key=/var/lib/tailscale/certs/${tailscale-domain}.key
            dst=/var/lib/actual/server-files/certs

            if [ ! -f "$src_crt" ] || [ ! -f "$src_key" ]; then
              echo "Tailscale certs not yet generated, skipping"
              exit 0
            fi

            install -d -m 0750 -o actual -g actual "$dst"
            install -m 0640 -o actual -g actual "$src_crt" "$dst/"
            install -m 0640 -o actual -g actual "$src_key" "$dst/"
          '';
        };
        after = [ "tailscaled.service" ];
        wantedBy = [ "multi-user.target" ];
      };

      systemd.timers.tailscale-certs-sync = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "2min";
          OnCalendar = "daily";
          RandomizedDelaySec = "1h";
        };
      };

      systemd.services.tailscale-certs-sync-daily = {
        description = "Refresh Tailscale certs and restart Actual";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "sync-and-restart" ''
            src_crt=/var/lib/tailscale/certs/nostromo.tail004be.ts.net.crt
            src_key=/var/lib/tailscale/certs/nostromo.tail004be.ts.net.key
            dst=/var/lib/actual/server-files/certs

            if [ ! -f "$src_crt" ] || [ ! -f "$src_key" ]; then
              exit 0
            fi

            install -d -m 0750 -o actual -g actual "$dst"
            install -m 0640 -o actual -g actual "$src_crt" "$dst/"
            install -m 0640 -o actual -g actual "$src_key" "$dst/"

            systemctl try-restart actual
          '';
        };
        after = [ "tailscaled.service" "actual.service" ];
      };

      # Watchdog: detecta cambios en el cert de Tailscale y dispara el servicio
      systemd.paths.tailscale-certs-sync = {
        pathConfig = {
          PathChanged = "/var/lib/tailscale/certs/${tailscale-domain}.crt";
          Unit = "tailscale-certs-sync.service";
        };
        wantedBy = [ "multi-user.target" ];
      };

      systemd.services.actual = {
        after = [
          "tailscaled.service"
          "tailscale-certs-sync.service"
        ];
        requires = [ "tailscale-certs-sync.service" ];
        wants = [ "tailscaled.service" ];
      };
    };
}
