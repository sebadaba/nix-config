{
  config,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = config.hostSpec.primaryUsername;
      };
      default_session = initial_session;
    };
  };
}
