{
  pkgs,
  ...
}:
{
  programs = {
    zsh = {
      enable = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    alacritty = {
      enable = true;
    };
  };
  home.packages = with pkgs; [
    xpipe
    neofetch
  ];
}
