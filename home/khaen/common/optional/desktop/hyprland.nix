{
  config,
  pkgs,
  ...
}:
let
  screenshotsFolder = "/home/${config.hostSpec.primaryUsername}/Pictures/Screenshots";
  hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      # Global
      "$terminal" = "alacritty";
      "$fileManager" = "thunar";
      #"$menu" = "rofi -show drun -show-icons";
      "$menu" = "anyrun";
      "$mainMod" = "SUPER";

      bind = [
        # Main
        "$mainMod, T, exec, $terminal"
        "$mainMod, C, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, F, togglefloating"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, ESCAPE, exec, wlogout-script"

        # Active window ($mainMod + arrow keys)
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspace ($mainMod + [0-9])
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to workspace ($mainMod + SHIFT + [0-9])
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through workspaces ($mainMod + scroll)
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Scratchpad
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Screenshots
        ", PRINT, exec, ${hyprshot} -m output --output-folder ${screenshotsFolder}" # Take screenshot of the whole screen
        "ALT, PRINT, exec, ${hyprshot} -m window -m active --output-folder ${screenshotsFolder}" # Take screenshot of the active window
        "SHIFT, PRINT, exec, ${hyprshot} -m region --output-folder ${screenshotsFolder}" # Take screenshot of a selected area
      ];

      # Binds that work when locked.
      bindl = [
        # Mute output audio
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        # Mute input audio
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        # Brightness +/- (0% - 100%)
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness +5"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness -5"
      ];

      # Binds that work when locked, and repeats if held down.
      bindel = [
        # Audio +/- (0% - 120%)
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume 6 --max-volume 120"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume -6 --max-volume 120"
      ];

      bindm = [
        # Move window ($mainMod + LMB)
        "$mainMod, mouse:272, movewindow"
        # Resize Window ($mainMod + RMB and drag)
        "$mainMod, mouse:273, resizeactive"
      ];
      exec-once = [
        "hyprlock --immediate-render"
        "hyprpaper"
        "waybar"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP" # For xdg-desktop-portal-hyprland
      ];
      windowrulev2 = [
        "float, class:(com.saivert.pwvucontrol)" # Volume control
        #"noanim, class:flameshot"
        #"float, title:(Extension: (Bitwarden Password Manager) - Bitwarden — LibreWolf)"
        #"float, title:(^Extension:.*-- Librewolf$)"
      ];

      layerrule = [
        "blur, logout_dialog" # blurs background when wlogout in use
      ];

      env = [
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
    };

    extraConfig = ''
      monitor=HDMI-A-2,3440x1440@100,0x0,1
      input {
          kb_layout = latam,us
          repeat_rate = 25
          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      }
      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = 10
          blur {
              enabled = true
              size = 3
              passes = 1
          }
      }
      animations {
          enabled = yes
          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }
      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = yes # you probably want this
      }
      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
      }
      xwayland {
        # Makes XWayland windows not look blurry/pixelated
        force_zero_scaling = true
      }
    '';

    xwayland.enable = true;
    systemd.enable = false; # UWSM compatibility
  };

  services.swayosd.enable = true;
}
