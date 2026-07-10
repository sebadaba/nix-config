{ inputs, ... }:
{
  flake.modules.homeManager.spicetify =
    { pkgs, ... }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

      programs.spicetify = {
        enable = true;
        wayland = true;
        enabledExtensions = with spicePkgs.extensions; [
          #adblockify
          #hidePodcasts
          #shuffle
        ];
        theme = spicePkgs.themes.comfy;
        colorScheme = "Comfy";
      };

      # seems like spicetify installed this way doesn't work with
      # noctalia's dynamic theming.
      # see https://github.com/Gerg-L/spicetify-nix/issues/323
      programs.noctalia.settings.theme.templates.community_ids = [ "spicetify" ];
    };
}
