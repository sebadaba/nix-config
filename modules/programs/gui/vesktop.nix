{
  flake.modules.homeManager.vesktop = {
    programs.vesktop = {
      enable = true;
      vencord.settings.enabledThemes = [ "noctalia.theme.css" ];
    };

    programs.noctalia-shell.settings.templates.activeTemplates = [
      {
        id = "discord";
        enabled = true;
      }
    ];
  };
}
