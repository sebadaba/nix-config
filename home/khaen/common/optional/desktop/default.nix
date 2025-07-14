{
  pkgs,
  ...
}:
{
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./rofi.nix
    ./screenshots.nix
    ./swaync.nix
    ./swayosd.nix
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
      qimgv
      ulauncher
      brightnessctl
      networkmanagerapplet
    ];
  };
}
