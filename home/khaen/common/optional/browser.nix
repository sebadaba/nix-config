{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  };
}
