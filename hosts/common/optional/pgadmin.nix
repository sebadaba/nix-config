# default: http://localhost:5050
{ inputs, config, ... }:
{
  services.pgadmin = {
    enable = true;
    initialEmail = inputs.nix-secrets.email.default;
    initialPasswordFile = config.sops.secrets."pgadmin_pass".path;
  };
  sops.secrets.pgadmin_pass = {
    owner = config.users.users.pgadmin.name;
    group = config.users.users.pgadmin.group;
    restartUnits = [ "pgadmin.service" ];
  };
}
