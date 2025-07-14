{
  pkgs,
  config,
  lib,
  ...
}:
let
  screenshotsFolder = "/home/${config.hostSpec.primaryUsername}/Pictures/Screenshots";
in
{
  home.packages = with pkgs; [
    grim
    slurp
    hyprshot
  ];
  wayland.windowManager.hyprland.settings.bind =
    lib.mkIf config.wayland.windowManager.hyprland.enable
      [
        ", PRINT, exec, hyprshot -m output --output-folder ${screenshotsFolder}" # Take screenshot of the whole screen
        "ALT, PRINT, exec, hyprshot -m window -m active --output-folder ${screenshotsFolder}" # Take screenshot of the active window
        "SHIFT, PRINT, exec, hyprshot -m region --output-folder ${screenshotsFolder}" # Take screenshot of a selected area
      ];
}
