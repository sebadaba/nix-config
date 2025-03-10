{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = {
    services.flameshot = {
      enable = true;
      package = pkgs.flameshot.override {enableWlrSupport = true;};
    };
  };
}
