{
  flake.modules.homeManager.zapfast = {pkgs,...}: {
    home.packages = with pkgs; [
      zapfast
    ];

    programs.noctalia.settings.theme.templates.community_ids = [ "zapfast" ];
  };
}
