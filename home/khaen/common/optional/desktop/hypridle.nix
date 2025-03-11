{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = {
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
        listener = [
          # Screenlock
          {
            timeout = 60 * 5; # in seconds
            on-timeout = "hyprlock"; # command to run when timeout has passed
            # on-resume = "notify-send \"Welcome back to your desktop!\"";  # command to run when activity is detected after timeout has fired.
          }
          # Monitor off
          {
            timeout = 60 * 20; # in seconds
            on-timeout = "hyprctl dispatch dpms off"; # command to run when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # command to run when activity is detected after timeout has fired.
          }
        ];
      };
    };
  };
}
