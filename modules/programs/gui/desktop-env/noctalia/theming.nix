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
      theme.templates.builtin_ids = [
        "gtk3"
        "gtk4"
        "kcolorscheme"
        "qt"
      ];
    };
  };
}
