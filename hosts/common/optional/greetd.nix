{
  config,
  ...
}:
let
  command =
    if config.hostSpec.wlCompositor == "Hyprland" then
      "uwsm start hyprland-uwsm.desktop"
    else if config.hostSpec.wlCompositor == "Niri" then
      "niri-session"
    else
      "/bin/sh";
in
{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = command;
        user = config.hostSpec.primaryUsername;
      };
      default_session = initial_session;
    };
  };
}
