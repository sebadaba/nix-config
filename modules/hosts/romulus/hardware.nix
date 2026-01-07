{
  ...
}:
{
  flake.modules.nixos.romulus = {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
      rtl-sdr.enable = true;
    };
  };
}
