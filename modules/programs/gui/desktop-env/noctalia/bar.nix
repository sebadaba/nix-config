{
  flake.modules.homeManager.noctalia = {
    programs.noctalia.settings.bar.main = {
      enabled = true;

      # Positioning
      position = "top";
      layer = "top";
      reserve_space = true;
      auto_hide = false;

      # Geometry and colors
      # TODO: dynamically change sizes based on screen res
      thickness = 34;
      background_opacity = 0.95;
      border = "outline";
      border_width = 0.2;
      shadow = true;
      contact_shadow = true;
      panel_overlap = 1;
      radius = 0; # global corner radius fallback
      radius_top_left = 0;
      radius_top_right = 0;
      radius_bottom_left = -12;
      radius_bottom_right = -12;
      margin_ends = 0; # full length
      margin_edge = 0; # attached to edge
      margin_opposite_edge = 0; # windows stick to bar

      # Widgets
      padding = 14; # from axis start/end
      widget_spacing = 10; # gap between widgets within a section
      hover_highlight = true;
      scale = 1.0; # for icons and text
      font_weight = "regular"; # "regular" or "bold"
      font_family = ""; # empty -> global font

      # Widget sections
      start = [
        "battery"
        "sysmon"
        "privacy"
        "workspaces"
      ];

      center = [
        "clock"
        "notifications"
      ];

      end = [
        "media"
        "tray"
        "network"
        "bluetooth"
        "volume"
        "brightness"
        "clipboard"
        "control-center"
      ];
    };
  };
}
