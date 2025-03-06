{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    #libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    # (catppuccin-papirus-folders.override {
    #   accent = "blue";
    #   flavor = "mocha";
    # })

    papirus-icon-theme
    xfce.thunar
  ];
  stylix = {
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      emoji = {
        package = pkgs.font-awesome;
        name = "Font Awesome";
      };
      sizes = {
        desktop = 14;
        terminal = 14;
        popups = 12;
      };
    };
    opacity = {
      desktop = 0.0;
      terminal = 0.65;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };
    targets = {
      kde.enable = true;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
    };
  };

  xdg.configFile = {
    qt5ct = {
      target = "qt5ct/qt5ct.conf";
      text = lib.generators.toINI {} {
        Appearance = {
          icon_theme = "Papirus-Dark";
        };
      };
    };
    qt6ct = {
      target = "qt6ct/qt6ct.conf";
      text = lib.generators.toINI {} {
        Appearance = {
          icon_theme = "Papirus-Dark";
        };
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
}
