{
  config.flake.factory.actual-budget = tailscale-domain:
    {pkgs,...}:{
      users = {
        users.actual = {
          isSystemUser = true;
          group = "actual";
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
          # Loopback only: tailscaled terminates TLS and proxies here.
          hostname = "127.0.0.1";
          # Trust tailscaled's proxy so req.protocol is https and req.ip
          # is the real client address.
          trustedProxies = [ "127.0.0.1/32" ];
        };
      };

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

      # tailscaled serves HTTPS for the MagicDNS name and proxies to
      # 127.0.0.1:5006. It renews the ACME certificate on its own (hourly
      # refresh loop with ARI) as long as the ServeConfig has an HTTPS entry.
      systemd.services.tailscale-serve-actual = {
        description = "Expose Actual through tailscale serve";
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ "${pkgs.tailscale}/bin/tailscale" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "10s";
          ExecStart = pkgs.writeShellScript "tailscale-serve-actual" ''
            set -euo pipefail

            # serve needs a logged-in backend.
            for _ in $(seq 1 60); do
              if ${pkgs.tailscale}/bin/tailscale status --json 2>/dev/null \
                   | ${pkgs.jq}/bin/jq -e '.BackendState == "Running"' >/dev/null 2>&1; then
                break
              fi
              sleep 1
            done

            ${pkgs.tailscale}/bin/tailscale serve --bg --https=5006 http://127.0.0.1:5006
          '';
        };
      };

      systemd.services.actual = {
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
