{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./anyrun.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./niri.nix
    ./rofi.nix
    ./swaync.nix
    ./theming.nix
    ./waybar.nix
    ./wlogout.nix
  ];
  home.packages = with pkgs; [
    hyprpaper
    wl-clipboard
    qimgv
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
  home.activation.removeMimeAppsBackups = lib.hm.dag.entryAfter [ "checkLinkTargets" ] ''
      if [ -d "${config.home.homeDirectory}/.config" ]; then
    		rm -f ${config.home.homeDirectory}/.config/mimeapps.list.backup
    	fi
  '';
}
