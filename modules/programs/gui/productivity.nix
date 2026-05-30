{
  flake.modules.homeManager.productivity =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        obsidian
        super-productivity
      ];
    };
}
