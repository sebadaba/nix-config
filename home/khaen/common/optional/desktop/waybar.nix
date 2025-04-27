# Most of the following configuration was retrieved from https://github.com/zDyanTB/HyprNova/tree/master/.config/waybar on September 2024.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  scheme = config.hostAttr.scheme;
in {
  config = {
    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          position = "top";
          height = 12;
          margin-left = 10;
          margin-right = 10;
          margin-top = 2;

          modules-left = [
            "custom/weather"
            "custom/separator#blank"
            "clock"
            "custom/separator#blank"
            "hyprland/window"
          ];
          modules-center = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "custom/notification"
            "custom/separator#blank"
            "tray"
            "custom/separator#blank"
            "mpris"
            "custom/separator#blank"
            "group/motherboard"
            "custom/separator#blank"
            "group/laptop"
            "custom/separator#blank"
            "group/audio"
            "custom/separator#blank"
            "network"
            "custom/separator#blank"
            "custom/power"
          ];

          # Module configurations

          # https://github.com/bjesus/wttrbar?tab=readme-ov-file#waybar-configuration
          "custom/weather" = {
            format = "{}°";
            tooltip = true;
            interval = 3600;
            exec = "wttrbar --location SCL"; # (Use your nearest airport's code)
            return-type = "json";
          };
          clock = {
            interval = 1;
            format = "{:%H:%M - %d/%b}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              week-pos = "right";
              on-scroll = 1;
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              #on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };

          "hyprland/window" = {
            format = "{}";
            max-length = 40;
            separate-outputs = true;
            offscreen-css = true;
            offscreen-css-text = "(inactive)";
          };

          "hyprland/workspaces" = {
            active-only = false;
            all-outputs = true;
            format = "{icon}";
            show-special = false;
            on-click = "activate";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            persistent-workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
            };
            format-icons = {
              active = "";
              default = "";
            };
          };
          tray = {
            icon-size = 15;
            spacing = 8;
          };

          "group/motherboard" = {
            orientation = "horizontal";
            modules = [
              "cpu"
              "memory"
              "temperature"
              "disk"
            ];
          };
          cpu = {
            format = "{usage}% 󰍛";
            interval = 1;
            format-alt-click = "click";
            format-alt = "{icon0}{icon1}{icon2}{icon3} {usage:>2}% 󰍛";
            format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
            # on-click =
          };
          memory = {
            interval = 10;
            format = "{used:0.1f}GB 󰾆";
            format-alt = "{percentage}% 󰾆";
            format-alt-click = "click";
            tooltip = true;
            tooltip-format = "{used:0.1f}GB/{total:0.1f}GB";
            # on-click =
          };
          temperature = {
            interval = 10;
            tooltip = true;
            hwmon-path = ["/sys/class/hwmon/hwmon1/temp1_input" "/sys/class/thermal/thermal_zone0/temp"];
            critical-threshold = 80;
            format-critical = "{temperatureC}°C {icon}";
            format = "{temperatureC}°C {icon}";
            format-icons = ["󰈸"];
          };
          disk = {
            interval = 30;
            path = "/";
            format = "{percentage_used}% 󰋊";
            tooltip-format = "{used} used out of {total} on {path} ({percentage_used}%)";
          };

          "group/laptop" = {
            orientation = "horizontal";
            modules = [
              "backlight"
              "battery"
            ];
          };

          "group/audio" = {
            orientation = "horizontal";
            modules = [
              "pulseaudio"
              #"pulseaudio#microphone"
            ];
          };

          "custom/power" = {
            format = " ";
            icon-size = 20;
            on-click = "wlogout-script";
            tooltip = false;
          };
          "custom/separator#blank" = {
            format = "";
            interval = "once";
            tooltip = false;
          };
          "custom/notification" = {
            tooltip = false;
            format = "{} {icon}";
            "format-icons" = {
              notification = "󱅫";
              none = "";
              "dnd-notification" = " ";
              "dnd-none" = "󰂛";
              "inhibited-notification" = " ";
              "inhibited-none" = "";
              "dnd-inhibited-notification" = " ";
              "dnd-inhibited-none" = " ";
            };
            "return-type" = "json";
            "exec-if" = "which swaync-client";
            exec = "swaync-client -swb";
            "on-click" = "sleep 0.1 && swaync-client -t -sw";
            "on-click-right" = "sleep 0.1 && swaync-client -d -sw";
            escape = true;
          };
        }
      ];
      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font";
          font-weight: bold;
          min-height: 0;
          /* set font-size to 100% if font scaling is set to 1.00 using nwg-look */
          font-size: 97%;
          font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
          padding: 1px;
        }

        window#waybar {
          background-color: rgba(255, 255, 255, 0.45);
          transition-property: background-color;
          transition-duration: 0.5s;
          background: transparent;
          border-radius: 10px;
        }
        window#waybar.hidden {
          opacity: 0.2;
        }
        #waybar.empty #window {
          background: none;
        }

        /* This section can be use if you want to separate waybar modules */
        .modules-left, .modules-center, .modules-right {
          background: ${scheme.withHashtag.base02}; /* Module background color */
          border: 1.2px solid ${scheme.withHashtag.base0D}; /* Module group border color */
          padding-top: 2px;
          padding-bottom: 2px;
          padding-right: 4px;
          padding-left: 4px;
          border-radius: 10px;
        }
        .modules-left, .modules-right {
          padding-top: 2px;
          padding-bottom: 2px;
          padding-right: 4px;
          padding-left: 4px;
        }
        tooltip label{
          background-color: ${scheme.withHashtag.base02}; /* Tooltip background color */
          color: ${scheme.withHashtag.base07}; /* Tooltip text color */
        }

        #clock {
          color: ${scheme.withHashtag.base07};
        }
        #cpu {
          color: ${scheme.withHashtag.base03};
        }
        #memory {
          color: ${scheme.withHashtag.base03};
        }
        #disk {
          color: ${scheme.withHashtag.base03};
        }
        #temperature {
          color: ${scheme.withHashtag.base03};
        }

        #workspaces button {
          box-shadow: none;
          text-shadow: none;
          padding: 0px;
          border-radius: 9px;
          padding-left: 4px;
          padding-right: 4px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.6s cubic-bezier(.55,-0.68,.48,1.682);
        }
        #workspaces button:hover {
          border-radius: 10px;
          background-color: rgba(255,255,255,0.2);
          padding-left: 2px;
          padding-right: 2px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
        }
        #workspaces button.persistent {
          color: rgba(255, 255, 255, 0.2);
          border-radius: 10px;
        }
        #workspaces button.active {
          color: ${scheme.withHashtag.base0D};
          border-radius: 10px;
          padding-left: 8px;
          padding-right: 8px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
        }
        #workspaces button.urgent {
          color: ${scheme.withHashtag.base0B};
          border-radius: 0px;
        }

        #taskbar button.active {
          padding-left: 8px;
          padding-right: 8px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.4s cubic-bezier(.55,-0.68,.48,1.682);
        }
        #taskbar button:hover {
          padding-left: 2px;
          padding-right: 2px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.4s cubic-bezier(.55,-0.68,.48,1.682);
        }
      '';
    };
    home.packages = with pkgs; [
      wttrbar # Weather custom module
    ];
  };
}
