{ inputs, ... }:
{
  flake.modules.nixos.vicinae = {
    home-manager.sharedModules = [ inputs.self.modules.homeManager.vicinae ];
  };

  flake.modules.homeManager.vicinae = {
    imports = [
      inputs.vicinae.homeManagerModules.default
    ];

    services.vicinae = {
      enable = true; # default: false
      systemd = {
        enable = true; # default: false
        autoStart = true; # default: false
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };
    };

    nix.settings = {
      extra-substituters = [ "https://vicinae.cachix.org" ];
      extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
    };

    programs.noctalia.settings.theme.templates.community_ids = [ "vicinae" ];
  };
}
