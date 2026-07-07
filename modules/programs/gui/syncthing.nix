{
  flake.modules.homeManager.syncthing = {
    services.syncthing = {
      enable = true;
      tray.enable = true; # Configuration wizard opens on first launch!
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
