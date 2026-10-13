{
  flake.modules.homeManager.zed =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "nix"
          "dockerfile"
          "latex"
        ];
        extraPackages = with pkgs; [
          nixd
          nixfmt
          (pkgs.texlive.combine {
            inherit (pkgs.texlive)
              scheme-medium
              titlesec
              enumitem
              fontawesome5
              ;
          })
          texlab
        ];
        userSettings = {
          features = {
            edit_prediction_provider = "copilot";
          };
          languages = {
            Nix = {
              language_servers = [ "nixd" ];
              lsp = {
                nixd = {
                  binary = {
                    path_lookup = true;
                  };
                };
              };
              formatter = {
                external = {
                  command = "nixfmt";
                };
              };
              colorize_brackets = true;
            };
          };
          theme = "Noctalia Dark";
        };
      };

      programs.noctalia.settings.theme.templates.community_ids = [ "zed" ];
    };
}
