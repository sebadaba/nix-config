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
    ./waybar.nix
    ./wlogout.nix
  ];

  config = {
    xdg.enable = true;
    home.packages = with pkgs; [
      libsForQt5.dolphin
      swww
      wl-clipboard
      grim
      slurp
      libsForQt5.qt5ct
      qimgv
      ulauncher
    ];
  };
}
