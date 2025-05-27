# default: http://localhost:8384/
{
  config,
  ...
}:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = config.hostSpec.primaryUsername;
    dataDir = "${config.users.users.${config.hostSpec.primaryUsername}.home}";
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
}
