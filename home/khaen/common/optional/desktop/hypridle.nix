{
  config,
  ...
}:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # lock_cmd = "notify-send \"lock!\""          # dbus/sysd lock command (loginctl lock-session)
        # unlock_cmd = "notify-send \"unlock!\"";      # same as above, but unlock
        ignore_dbus_inhibit = false; # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };
      listener =
        let
          dpms-off-cmd =
            if config.hostSpec.wlCompositor == "Hyprland" then
              "hyprctl dispatch dpms off"
            else if config.hostSpec.wlCompositor == "Niri" then
              "niri msg action power-off-monitors" # uses dpms
            else
              "";
          dpms-on-cmd =
            if config.hostSpec.wlCompositor == "Hyprland" then "hyprctl dispatch dpms on" else ""; # niri doesn't need a "on-command"
        in
        [
          # Screen Dim (Laptop mostly)
          {
            timeout = 90;
            on-timeout = "brightnessctl -s set 10 "; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }
          # Screen lock
          {
            timeout = 180;
            on-timeout = "pidof hyprlock || hyprlock"; # command to run when timeout has passed
            # on-resume = "notify-send \"Welcome back to your desktop!\"";  # command to run when activity is detected after timeout has fired.
          }
          # Monitor off
          {
            timeout = 200;
            on-timeout = dpms-off-cmd; # command to run when timeout has passed
            on-resume = dpms-on-cmd; # command to run when activity is detected after timeout has fired.
          }
        ];
    };
  };
}
