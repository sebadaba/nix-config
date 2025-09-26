{
  config,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {

    };
  };
  services.blueman.enable = if config.hostSpec.wlCompositor != "None" then true else false;
}
