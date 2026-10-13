{
  flake.modules.homeManager.noctalia = {pkgs, ...}:{
    gtk = {
      enable = true;
      gtk3 = {
        enable = true;
        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
      };
    };
    home.packages = with pkgs; [
      qt6Packages.qt6ct
    ];
    programs.noctalia.settings = {
      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-rainbow";
        templates = {
          enable_builtin_templates = true;
          enable_community_templates = true;
          builtin_ids = [
            "gtk3"
            "gtk4"
            "kcolorscheme"
            "qt"
          ];
        };
      };
    };
  };
}
