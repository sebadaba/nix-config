{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.hostSpec = {
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
    wlCompositor = lib.mkOption {
      type = lib.types.enum [
        "Hyprland"
        "Niri"
        "None"
      ];
      default = "None";
      description = "The Wayland compositor to use on this host, if any";
    };
  };
}
