{
  config,
  lib,
  pkgs,
  inputs,
  scheme,
  ...
}: {
  config = {
    services.flameshot = {
      enable = true;
      package = pkgs.flameshot.override {enableWlrSupport = true;};
    };
  };
}
