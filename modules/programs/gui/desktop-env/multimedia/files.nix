{
  flake.modules.homeManager.files =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nemo-with-extensions
      ];

      xdg = {
        desktopEntries.nemo = {
          name = "Nemo";
          exec = "${pkgs.nemo-with-extensions}/bin/nemo";
        };

        mimeApps.defaultApplications = {
          "inode/directory" = [ "nemo.desktop" ];
          "application/x-gnome-saved-search" = [ "nemo.desktop" ];
        };
      };
    };
}
