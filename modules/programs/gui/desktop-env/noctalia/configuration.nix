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
      #services.noctalia-shell.enable = true;

      services.gnome.evolution-data-server.enable = true; # Calendar support
    };

  flake.modules.homeManager.noctalia =
    { pkgs, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia-shell = {
        enable = true;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          calendarSupport = true;
        };
        systemd.enable = true; # target is set by wayland.systemd.target
        settings = {
          #templates.enableUserTemplates = true;

          general = {
            compactLockScreen = true;
            showSessionButtonsOnLockScreen = false;
          };

          location = {
            name = "Santiago, Chile";
          };

          colorSchemes = {
            darkMode = true;
            predefinedScheme = "Ayu";
            useWallpaperColors = true;
            generationMethod = "rainbow";
          };

          wallpaper = {
            enabled = true;
            overviewEnabled = true;
          };

          osd = {
            enabled = true;
            location = "bottom";
            backgroundOpacity = 0.75;
            enabledTypes = [
              0 # Output volume
              1 # Input volume
              2 # Brightness
              3 # Lock keys (caps, num...)
            ];
          };

          hooks = {
            enabled = true;
            startup = "noctalia-shell ipc call lockScreen lock";
          };
        };
      };

      programs.niri.settings = {
        # Sets overview wallpaper to a blurred version of the desktop wallpaper.
        # Requires "Wallpaper" > "Enable overview wallpaper" in noctalia config.
        # (or programs.noctalia-shell.settings.wallpaper.overviewEnabled = true;)
        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-overview*"; } ];
            place-within-backdrop = true;
          }
        ];
      };
    };
}
