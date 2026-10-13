{
  flake.modules.homeManager.noctalia = {
    programs.noctalia.settings = {
      idle = {
        behavior_order = [
          "lock"
          "screen-off"
        ];
        pre_action_fade_seconds = 2.5;

        behavior = {
          lock = {
            timeout = 600;
            action = "lock";
            enabled = true;
          };
          screen-off = {
            timeout = 600;
            action = "screen_off";
            enabled = true;
          };
        };
      };
    };
  };
}
