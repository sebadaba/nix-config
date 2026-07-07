{
  flake.modules.homeManager.vesktop = {
    programs.vesktop = {
      enable = true;
      vencord.settings.enabledThemes = [ "noctalia.theme.css" ];
    };

    programs.noctalia.settings.templates.activeTemplates = [
      {
        id = "discord";
        enabled = true;
      }
    ];
  };
}
