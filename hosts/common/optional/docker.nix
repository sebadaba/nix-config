# default: http://localhost:8384/
{
  config,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
  };
  users.extraGroups.docker.members = [ config.hostSpec.primaryUsername ];
}
