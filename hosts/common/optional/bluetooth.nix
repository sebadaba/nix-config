{
  pkgs,
  config,
  lib,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      
    };
  };
  services.blueman.enable = lib.mkIf config.programs.hyprland.enable true;
}
