{
  inputs,
  ...
}:
{
  flake.modules.nixos.sevastopol =
    { pkgs, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        with inputs.self.factory;
        [
          basic-system
          (btrfs-subvolumes {
            primary-disk = "/dev/nvme0n1";
            swapFileSize = "3G";
          })
        ];

      services = {
        tuned.enable = true;
        upower.enable = true;
        thinkfan.enable = true;
        openssh.enable = true;
        tailscale.enable = true;
        logind.settings.Login = {
          HandleLidSwitch = "ignore";
          HandleLidSwitchDocked = "ignore";
          HandleLidSwitchExternalPower = "ignore";
        };
      };

      networking = {
        hostName = "sevastopol";
        networkmanager.enable = true;
      };

      system.stateVersion = "25.11";

      virtualisation.libvirtd.enable = true;

      hardware = {
        enableAllFirmware = true;
        #enableRedistributableFirmware = true;
        firmware = [ pkgs.linux-firmware ];
      };

      #hardware.facter.reportPath = ./facter.json;

      nixpkgs.config.allowUnfree = true;

      boot.loader = {
        systemd-boot = {
          enable = true;
          consoleMode = "2";
        };
        efi = {
          canTouchEfiVariables = true;
          #efiSysMountPoint = "/boot/efi";
        };
      };

    };
}
