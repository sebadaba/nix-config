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

      services.gnome.evolution-data-server.enable = true; # Calendar support
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

          theme = {
            mode = "dark";
            source = "wallpaper";
            wallpaper_scheme = "m3-rainbow";
            templates = {
              enable_builtin_templates = true;
              enable_community_templates = true;
            };
          };

          backdrop = {
            enabled = true;
            blur_intensity = 0.25;
            tint_intensity = 0.1;
          };

          location.auto_locate = true;

          osd.position = "bottom_center";
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
