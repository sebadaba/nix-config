{
  flake.modules.homeManager.productivity =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        obsidian
        super-productivity
        # upstream fix: https://github.com/NixOS/nixpkgs/commit/88f44a62 (not yet in nixos-unstable)
        (anki.overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.pkg-config ];
          buildInputs = old.buildInputs ++ [
            pkgs.sqlite
            pkgs.zstd
          ];
          env = old.env // {
            UV_FIND_LINKS = "${old.env.UV_FIND_LINKS},${pkgs.python3Packages.tomlkit.dist}";
          };
        }))
      ];
    };
}
