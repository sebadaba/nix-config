{
  flake.modules.homeManager.coding-agent =
    { pkgs, ... }:
    {
      programs = {
        opencode = {
          enable = true;
          enableMcpIntegration = true;
          settings = {
            tools = {
              "markitdown_*" = false;
            };
          };
          agents = {
            summarizer = ./agents/summarizer.md;
          };
          skills = {
            read-documents = ./skills/read-documents.md;
          };
        };

        mcp = {
          enable = true;
          servers = {
            markitdown = {
              enabled = true;
              command = "${pkgs.markitdown-mcp}/bin/markitdown-mcp";
            };
          };
        };
      };
    };
}
