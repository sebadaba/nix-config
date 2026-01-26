{
  flake.modules.homeManager.video =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        celluloid
      ];

      xdg.mimeApps.defaultApplications = {
        "video/matroska" = "org.gnome.Celluloid.desktop"; # .mkv
        "video/mp4" = "org.gnome.Celluloid.desktop"; # .mp4
      };
    };
}
