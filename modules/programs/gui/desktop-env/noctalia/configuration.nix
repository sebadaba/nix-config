{ inputs, ... }:
{
  flake.modules.nixos.noctalia =
    { config, ... }:
    {
      imports = with inputs; [ noctalia.nixosModules.default ];
      home-manager.sharedModules = [
        (inputs.self.modules.homeManager.noctalia { usingTailscale = config.services.tailscale.enable; })
      ];
      # systemd service. starts after graphical-session target
      #services.noctalia.enable = true;

      environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";
    };

  flake.modules.homeManager.noctalia =
    { pkgs, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      home.packages = with pkgs; [
        networkmanagerapplet # as a fallback
      ];

      programs.noctalia = {
        enable = true;
        settings = {
          #templates.enableUserTemplates = true;

          backdrop = {
            enabled = true;
            blur_intensity = 0.25;
            tint_intensity = 0.1;
          };

          location.auto_locate = true;

          osd.position = "bottom_center";

          hooks.started = "noctalia msg session lock";
        };
      };

      programs.niri.settings = {
        spawn-at-startup = [ { argv = [ "noctalia" ]; } ]; # Niri automatic startup

        # Sets overview wallpaper to a blurred version of the desktop wallpaper.
        # Requires "Wallpaper" > "Enable overview wallpaper" in noctalia config.
        # (or programs.noctalia-shell.settings.wallpaper.overviewEnabled = true;)
        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-backdrop"; } ];
            place-within-backdrop = true;
          }
          {
            matches = [ { namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"; } ];
            #background-effect = {
            #  xray = false;
            #};
          }
        ];

        window-rules = [
          {
            matches = [ { app-id = "dev.noctalia.Noctalia"; } ];
            open-floating = true;
          }
        ];

      };
    };
}
