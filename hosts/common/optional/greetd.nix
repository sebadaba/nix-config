{
  pkgs,
  config,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = config.hostAttr.primaryUsername;
      };
      default_session = initial_session;
    };
  };
}
