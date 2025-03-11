{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./flameshot.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./rofi.nix
    ./theming.nix
    ./waybar.nix
    ./wlogout.nix
  ];

  config = {
    xdg.enable = true;
    home.packages = with pkgs; [
      libsForQt5.dolphin
      hyprpaper
      wl-clipboard
      grim
      slurp
      qimgv
      ulauncher
    ];
  };
}
