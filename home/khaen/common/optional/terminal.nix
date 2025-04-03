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
    wezterm = {
      enable = true;
    };
  };
  home.packages = with pkgs; [
    xpipe
    neofetch
  ];
}
