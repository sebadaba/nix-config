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
  home.packages = with pkgs; [
    libsForQt5.dolphin
    hyprpaper
    wl-clipboard
    qimgv
    ulauncher
    brightnessctl
    networkmanagerapplet
    evince
  ];
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/png" = "qimgv.desktop";
        "image/jpeg" = "qimgv.desktop";
        "image/gif" = "qimgv.desktop";
        "image/webp" = "qimgv.desktop";
        "application/pdf" = "org.gnome.Evince.desktop";
      };
    };
  };
}
