{
  flake.modules.homeManager.noctalia = {
    programs.noctalia.settings.bar = {
      density = "compact";
      position = "top";
      widgets = {
        left = [
          {
            id = "Clock";
            formatHorizontal = "hh:mm AP";
            formatVertical = "HH mm";
            usePrimaryColor = true;
          }
          {
            id = "Battery";
            alwaysShowPercentage = false;
            warningThreshold = 30;
          }
          {
            id = "SystemMonitor";
            compactMode = true;
            showCpuUsage = true;
            showCpuTemp = true;
            showMemoryUsage = true;
          }
          {
            id = "plugin:catwalk";
          }
          {
            id = "plugin:privacy-indicator";
            defaultSettings = {
              hideInactive = true;
              removeMargins = true;
            };
          }
        ];
        center = [
          {
            id = "Workspace";
            hideUnoccupied = false;
            labelMode = "index";
          }
        ];
        right = [
          {
            id = "Tray";
          }
          {
            id = "plugin:pomodoro";
          }
          {
            id = "NotificationHistory";
            hideWhenZero = false;
            hideWhenZeroUnread = false;
          }
          {
            id = "Network";
          }
          {
            id = "Bluetooth";
          }
          {
            id = "Volume";
          }
          {
            id = "Brightness";
          }
          {
            id = "ControlCenter";
            useDistroLogo = true;
          }
        ];
      };
    };
  };
}
