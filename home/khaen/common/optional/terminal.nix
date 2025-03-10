{
  pkgs,
  lib,
  config,
  ...
}: {
  programs = {
    zsh = {
      enable = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    foot = {
      enable = true;
      server.enable = true;
    };
  };
  home.packages = with pkgs; [
    xpipe
    neofetch
  ];
}
