# Most of the following configuration was retrieved from https://github.com/zDyanTB/HyprNova/tree/master/.config/wlogout on September 2024.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with pkgs;
let
  # ========== Icon Download ==========
  icons = {
    url = "https://raw.githubusercontent.com/zDyanTB/HyprNova/c39f826448fa046c0acae3fd652180e69b6909a9/.config/wlogout/icons/";

    hibernate-hover = fetchurl {
      url = "${icons.url}/hibernate-hover.png";
      hash = "sha256-nvtO7QiEnwuMBmVM7f2RvRDIpxpACetx2SiYvcq+SHc=";
    };
    hibernate = fetchurl {
      url = "${icons.url}/hibernate.png";
      hash = "sha256-5zwSItw/s/v8H/3zo51QOqkDj4hyLnHGVFO7+VB9RHQ=";
    };
    lock-hover = fetchurl {
      url = "${icons.url}/lock-hover.png";
      hash = "sha256-jx1X3LRk82OuFChiM30qpV73wRp2os75Wl0nWu5g4cU=";
    };
    lock = fetchurl {
      url = "${icons.url}/lock.png";
      hash = "sha256-MLaM8v65S1lMjfSr6mT/jo1L6m8Zl2a7g7hGgxPX+kA=";
    };
    logout-hover = fetchurl {
      url = "${icons.url}/logout-hover.png";
      hash = "sha256-F7Qg3j2r8tOBTgByNoahtdQlePHmA6PHAOQ9++kIkMU=";
    };
    logout = fetchurl {
      url = "${icons.url}/logout.png";
      hash = "sha256-weETN/il3enY4vYo/1BbADNyn8tY9F4o3Z7oQhQAA+k=";
    };
    power-hover = fetchurl {
      url = "${icons.url}/power-hover.png";
      hash = "sha256-rhk9BIZzOnFn94TfDaSdhhYffEinbKfc7+YjijgTiQU=";
    };
    power = fetchurl {
      url = "${icons.url}/power.png";
      hash = "sha256-0559QADJ7on0Qtbj6c41XPFQEGzTMIJkyFSj0N4exiM=";
    };
    restart-hover = fetchurl {
      url = "${icons.url}/restart-hover.png";
      hash = "sha256-RVhJtE2ZnBXlTE6WeiNWOhld+gVJMCpCorPUC2rdqF4=";
    };
    restart = fetchurl {
      url = "${icons.url}/restart.png";
      hash = "sha256-Fi7RI5M1FyoPIIcoYE0MotgPq2xJyGKZaAepAcqfn3c=";
    };
  };
  # -------------------------------------
  wlogout-script = pkgs.writeShellScriptBin "wlogout-script" ''
    A_1080=400
    B_1080=400

    # Check if wlogout is already running
    if pgrep -x "wlogout" > /dev/null; then
        pkill -x "wlogout"
        exit 0
    fi

    # Detect monitor resolution and scaling factor
    resolution=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height / .scale' | awk -F'.' '{print $1}')
    hypr_scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale')
    wlogout --protocol layer-shell -b 5 -T $(awk "BEGIN {printf \"%.0f\", $A_1080 * 1080 * $hypr_scale / $resolution}") -B $(awk "BEGIN {printf \"%.0f\", $B_1080 * 1080 * $hypr_scale / $resolution}") &
  '';
  scheme = config.hostSpec.scheme;
in
{
  config = {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "logout";
          action = "loginctl kill-session $XDG_SESSION_ID";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "hibernate";
          action = "swaylock -f && systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
        }
      ];
      style = ''
        window {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 16pt;
          background-color: rgba(24, 27, 32, 0.2);
        }

        button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          background-color: transparent;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s ease-in;
          box-shadow: 0 0 10px 2px transparent;
          color: ${scheme.withHashtag.base0D};
          border-radius: 36px;
          margin: 10px;
        }

        button:focus {
          box-shadow: none;
          background-size : 20%;
        }

        button:hover {
          background-size: 50%;
          box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
          background-color: ${scheme.withHashtag.base0D};
          color: transparent;
          transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
        }

        #shutdown {
          background-image: image(url("${icons.power}"));
        }
        #shutdown:hover {
          background-image: image(url("${icons.power-hover}"));
        }

        #logout {
          background-image: image(url("${icons.logout}"));
        }
        #logout:hover {
          background-image: image(url("${icons.logout-hover}"));
        }

        #reboot {
          background-image: image(url("${icons.restart}"));
        }
        #reboot:hover {
          background-image: image(url("${icons.restart-hover}"));
        }

        #lock {
          background-image: image(url("${icons.lock}"));
        }
        #lock:hover {
          background-image: image(url("${icons.lock-hover}"));
        }

        #hibernate {
          background-image: image(url("${icons.hibernate}"));
        }
        #hibernate:hover {
          background-image: image(url("${icons.hibernate-hover}"));
        }
      '';
    };
    home.packages = with pkgs; [
      jq
      wlogout-script
    ];
  };
}
