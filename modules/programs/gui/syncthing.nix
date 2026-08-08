{
  flake.modules.homeManager.syncthing = {
    services.syncthing = {
      enable = true;
      # Configuration wizard opens on first launch!
      # TODO: Fix synchting tray "Unable to request syncthing config" error
      #tray.enable = true;
      overrideDevices = false;
      overrideFolders = false;
      settings = {
        gui = {
          theme = "black";
        };
      };
    };
  };
}
