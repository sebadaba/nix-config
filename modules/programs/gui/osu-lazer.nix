{inputs,...}: {
  flake.modules.nixos.osu-lazer = {
    home-manager.sharedModules = [ inputs.self.modules.homeManager.osu-lazer ];
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
  flake.modules.homeManager.osu-lazer =
  {pkgs, ...}:
  {
    home.packages = with pkgs; [osu-lazer-bin];
  };
}
