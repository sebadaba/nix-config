{
  inputs,
  ...
}:
{
  flake.modules.nixos.communication = {
    home-manager.sharedModules = [ inputs.self.modules.homeManager.communication ];
  };

  flake.modules.homeManager.communication = {
    imports = with inputs.self.modules.homeManager; [
      vesktop
      zapfast
    ];
  };
}
