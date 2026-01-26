{
  flake.modules.nixos.greetd = {
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "niri-session";
          user = "khaen";
        };
        default_session = initial_session;
      };
    };
  };
}
