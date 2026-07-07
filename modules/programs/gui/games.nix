{
  inputs,
  ...
}:
{
  flake.modules = {
    nixos.games =
      { pkgs, ... }:
      {
        home-manager.sharedModules = [ inputs.self.modules.homeManager.games ];
        programs = {
          steam = {
            enable = true;
            package = pkgs.steam.override {
              extraEnv = {
                DISPLAY = ":0";
              };
            };
            gamescopeSession.enable = true;
            protontricks = {
              enable = true;
              package = pkgs.protontricks;
            };
          };
          gamescope.enable = true;
          gamemode.enable = true;
        };
      };

    homeManager.games =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          # Minecraft Launcher
          prismlauncher

          # Epic Games launcher
          (heroic.override {
            extraPkgs =
              pkgs': with pkgs'; [
                gamescope
                gamemode
              ];
          })
        ];
      };
  };

}
