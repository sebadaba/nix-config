{
  config,
  ...
}:
{
  sops.secrets."librenms-password-file" = {
    mode = "0400";
    owner = "librenms";
    group = "librenms";
  };

  users.users.librenms = {
    isSystemUser = true;
    group = "librenms";
  };

  users.groups.librenms = { };

  services.librenms = {
    database = {
      createLocally = true;
      passwordFile = config.sops.secrets."librenms-password-file".path;
    };
  };
}
