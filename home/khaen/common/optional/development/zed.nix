{
  pkgs,
  ...
}:
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
    };
  };
}
