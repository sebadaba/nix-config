{
  flake.modules.homeManager.development =
    { pkgs, ... }:
    {
      programs = {
        git = {
          enable = true;
          package = pkgs.gitFull;
        };

        gitui.enable = true;

        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
      };
      home.packages = with pkgs; [
        devenv
      ];
    };
}
