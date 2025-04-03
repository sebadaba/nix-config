{
  config,
  lib,
  pkgs,
  inputs,
  scheme,
  ...
}: {
  services.swaync = {
    enable = true;
  };
}
