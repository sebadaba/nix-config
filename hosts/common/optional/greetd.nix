{
  config,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = config.hostSpec.primaryUsername;
      };
      default_session = initial_session;
    };
  };
}
