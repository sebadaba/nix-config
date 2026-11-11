{
  flake.modules.homeManager.zapfast = {pkgs,...}: {
    # upstream fix: https://github.com/NixOS/nixpkgs/commit/eb481bab (not yet in nixos-unstable)
    home.packages = [
      (pkgs.zapfast.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [
          pkgs.openssl
          pkgs.sqlcipher
        ];
      }))
    ];

    programs.noctalia.settings.theme.templates.community_ids = [ "zapfast" ];
  };
}
