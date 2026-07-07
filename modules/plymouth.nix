{ ... }:
let
  # Available themes: https://github.com/adi1090x/plymouth-themes
  theme-name = "lone";
in
{
  flake.modules.nixos.plymouth =
    { pkgs, ... }:
    {
      boot = {
        plymouth = {
          enable = true;
          theme = theme-name;
          themePackages = with pkgs; [
            # Download only the selected theme instead of all themes
            (adi1090x-plymouth-themes.override {
              selected_themes = [ theme-name ];
            })
          ];
        };

        # "Silent boot"
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ];
      };
    };
}
