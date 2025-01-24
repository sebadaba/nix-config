# git is core no matter what but additional settings may could be added made in optional/foo   eg: development.nix
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    extraConfig = {
      user = {
        email = inputs.nix-secrets.email.github;
        name = inputs.nix-secrets.fullName;
      };
    };
  };
}
