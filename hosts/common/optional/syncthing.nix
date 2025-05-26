# default: http://localhost:8384/
{
  config,
  ...
}:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = config.hostAttr.primaryUsername;
    dataDir = "${config.users.users.${config.hostAttr.primaryUsername}.home}";
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
}
