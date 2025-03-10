# Most of the following configuration was retrieved from https://github.com/zDyanTB/HyprNova/blob/master/.config/hypr/hyprlock.conf on September 2024.
{
  config,
  lib,
  pkgs,
  inputs,
  scheme,
  ...
}: {
  config = {
    programs.hyprlock = {
      enable = true;
      settings = {
        background = {
          monitor = "";
          path = lib.mkDefault "/home/amadeus/.dotfiles/resources/wallpapers/sunrise-mountain-416BF.png";
          blur_size = 4;
          blur_passes = 3; # 0 disables blurring
          noise = 0.0117;
          contrast = 1.3000; # Vibrant
          brightness = 0.8000;
          vibrancy = 0.2100;
          vibrancy_darkness = 0.0;
        };
        label = [
          {
            # Hours
            monitor = "";
            text = "cmd[update:1000] echo \"<b><big> $(date +\"%H\") </big></b>\"";
            color = "$color6";
            font_size = 112;
            font_family = "Geist Mono 10";
            shadow_passes = 3;
            shadow_size = 4;

            position = "0, 220";
            halign = "center";
            valign = "center";
          }
          {
            # Minutes
            monitor = "";
            text = "cmd[update:1000] echo \"<b><big> $(date +\"%M\") </big></b>\"";
            color = "$color6";
            font_size = 112;
            font_family = "Geist Mono 10";
            shadow_passes = 3;
            shadow_size = 4;

            position = "0, 80";
            halign = "center";
            valign = "center";
          }
          {
            # Today
            monitor = "";
            text = "cmd[update:18000000] echo \"<b><big> \"$(date +'%A')\" </big></b>\"";
            color = "$color7";
            font_size = 22;
            font_family = "JetBrainsMono Nerd Font 10";

            position = "0, -15";
            halign = "center";
            valign = "center";
          }
          {
            # Week
            monitor = "";
            text = "cmd[update:18000000] echo \"<b> \"$(date +'%d %b')\" </b>\"";
            color = "$color7";
            font_size = 18;
            font_family = "JetBrainsMono Nerd Font 10";

            position = "0, -40";
            halign = "center";
            valign = "center";
          }
          {
            # Degrees
            monitor = "";
            text = "cmd[update:18000000] echo \"<b>Feels like<big> $(curl -s 'wttr.in/SCL?format=%t' | tr -d '+') </big></b>\"";
            color = "$color7";
            font_size = 18;
            font_family = "Geist Mono 10";

            position = "0, 40";
            halign = "center";
            valign = "bottom";
          }
        ];
        input-field = {
          monitor = "";
          size = "250, 50";
          outline_thickness = 3;

          dots_size = 0.26; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.64; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          dots_rouding = -1;

          rounding = 22;
          #outer_color = "$color0";
          #inner_color = "$color0";
          #font_color = "$color6";
          fade_on_empty = "true";
          placeholder_text = "<i>Password...</i>"; # Text rendered in the input box when it's empty.

          position = "0, 120";
          halign = "center";
          valign = "bottom";
        };
      };
    };
  };
}
