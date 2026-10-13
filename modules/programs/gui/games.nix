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
          gamemode.enable = true;
          gamescope = {
            enable = true;
            args = [
              "--output-width 3440"
              "--nested-width 3440"
              "--output-height 1440"
              "--nested-height 1440"
              "--fullscreen"
              "--mangoapp"
            ];
          };

        };
      };

    homeManager.games =
      { pkgs, ... }:
      {
        programs.mangohud.enable = true;
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
