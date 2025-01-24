{
  config,
  pkgs,
  lib,
  ...
}: {
  options.hostAttr = {
    primaryUsername = lib.mkOption {
      type = lib.types.str;
      description = "The username of the host's primary user";
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the host";
    };
    scheme = lib.mkOption {
      type = lib.types.attrs;
      description = "Color scheme of the host";
    };
  };
}
