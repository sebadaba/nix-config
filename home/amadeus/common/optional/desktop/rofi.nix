{
  config,
  lib,
  pkgs,
  inputs,
  scheme,
  ...
}: {
  config = {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = "${config.xdg.configHome}/rofi/archcraft-openbox-default/launcher.rasi";
    };
    xdg.configFile = {
      "rofi/archcraft-openbox-default/launcher.rasi".source = pkgs.fetchurl {
        url = https://raw.githubusercontent.com/archcraft-os/archcraft-openbox/refs/heads/main/files/themes/default/rofi/launcher.rasi;
        hash = "sha256-dK/b/4QMtS+cCm3Ny2I7DcYcyupbj2NidCom2XN1xkQ=";
      };
      "rofi/archcraft-openbox-default/shared/colors.rasi".text = ''
        * {
            background:     #1E2128;
            background-alt: #292d37;
            foreground:     #ABB2BF;
            selected:       #5294E2;
            active:         #98C379;
            urgent:         #E06B74;
        }
      '';
      "rofi/archcraft-openbox-default/shared/fonts.rasi".text = ''
        * {
            font: "JetBrainsMono Nerd Font 12";
        }
      '';
    };

    stylix.targets.rofi.enable = false;
  };
}
