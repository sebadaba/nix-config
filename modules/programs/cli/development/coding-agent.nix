{
  flake.modules.homeManager.coding-agent =
    { ... }:
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
            #summarizer = ./agents/summarizer.md;
          };
          skills = {
            #read-documents = ./skills/read-documents.md;
          };
        };

        mcp = {
          enable = true;
          servers = {
            # markitdown = {
            #enabled = true;
            #command = "${pkgs.markitdown-mcp}/bin/markitdown-mcp";
            #};
            context7 = {
              enable = true;
              url = "https://mcp.context7.com/mcp";
              headers.CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
            };
          };
        };
      };
    };
}
