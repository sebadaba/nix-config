{
  inputs,
  ...
}:
{
  flake.modules.nixos.nostromo =
    { pkgs, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        with inputs.self.factory;
        [
          basic-system
          (btrfs-subvolumes {
            primary-disk = "/dev/nvme1n1";
            swapFileSize = "12G";
          })
          audio
          plymouth
          desktop-env
          #...
        ];

      services = {
        tuned.enable = true;
        openssh.enable = true;
        tailscale.enable = true;
      };

      networking = {
        hostName = "nostromo";
        networkmanager.enable = true;
      };

      system.stateVersion = "26.05";

      virtualisation.vmVariant = {
        virtualisation = {
          memorySize = 4096;
          cores = 2;
        };

      };

      hardware = {
        enableAllFirmware = true;
        #enableRedistributableFirmware = true;
        firmware = [ pkgs.linux-firmware ];
      };

      hardware.facter.reportPath = ./facter.json;

      nixpkgs.config.allowUnfree = true;

      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
    };
}
