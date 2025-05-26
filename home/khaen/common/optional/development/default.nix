{
  pkgs,
  ...
}:
{
  imports = [
    ./c.nix
    ./java.nix
    #./python.nix
    ./vscode.nix
  ];
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
  home.packages = with pkgs; [
    devenv
  ];
}
