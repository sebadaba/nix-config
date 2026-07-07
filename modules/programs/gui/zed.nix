{
  flake.modules.homeManager.zed =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "nix"
          "dockerfile"
        ];
        extraPackages = with pkgs; [
          nixd
          nixfmt
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

      programs.noctalia.settings.templates.activeTemplates = [
        {
          id = "zed";
          enabled = true;
        }
      ];
    };
}
