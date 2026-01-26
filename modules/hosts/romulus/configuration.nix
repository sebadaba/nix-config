{
  inputs,
  ...
}:
{
  flake.modules.nixos.romulus =
    { pkgs, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        [
          audio
          plymouth
          desktop-env
          #...
        ]
        ++ [ inputs.self.modules.generic.constants ];

      services = {
        openssh.enable = true;
        tailscale.enable = true;
      };

      networking = {
        hostName = "romulus";
        networkmanager.enable = true;
      };

      system.stateVersion = "24.11";

      virtualisation.vmVariant = {
        virtualisation = {
          memorySize = 4096;
          cores = 2;
        };

      };

      hardware = {
        graphics.enable = true;
        enableAllFirmware = true;
        #enableRedistributableFirmware = true;
        firmware = [ pkgs.linux-firmware ];
      };

      nixpkgs.config.allowUnfree = true;
    };
}
