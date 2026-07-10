{ inputs, ... }:
{
  flake.modules.nixos.alacritty = {
    home-manager.sharedModules = [ inputs.self.modules.homeManager.alacritty ];
  };

  flake.modules.homeManager.alacritty = {

    programs.alacritty = {
      enable = true;
      settings.window.opacity = 0.80;
    };

    programs.noctalia.settings.theme.templates.builtin_ids = [ "alacritty" ];
  };
}
