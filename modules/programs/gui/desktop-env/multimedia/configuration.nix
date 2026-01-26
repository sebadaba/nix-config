{
  inputs,
  ...
}:
{
  flake.modules.nixos.multimedia = {
    home-manager.sharedModules = [ inputs.self.modules.homeManager.multimedia ];
  };

  flake.modules.homeManager.multimedia = {
    imports = with inputs.self.modules.homeManager; [
      image
      office
      pdf
      video
    ];

    xdg = {
      enable = true;
      mimeApps.enable = true;
    };
    # ls ~/.local/state/nix/profiles/home-manager/home-path/share/applications
    # to get the .desktop files installed by home-manager
  };
}
