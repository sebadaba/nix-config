{
  flake.modules.homeManager.image =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        loupe
      ];

      xdg.mimeApps.defaultApplications = {
        "image/png" = "org.gnome.Loupe.desktop"; # .png
        "image/jpeg" = "org.gnome.Loupe.desktop"; # .jpeg
      };
    };
}
