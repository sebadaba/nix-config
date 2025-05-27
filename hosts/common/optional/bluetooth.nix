{
  config,
  lib,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {

    };
  };
  services.blueman.enable = lib.mkIf config.programs.hyprland.enable true;
}
