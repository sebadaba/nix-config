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
        [
          basic-system
          audio
          plymouth
          desktop-env
          #...
        ];

      services = {
        tuned.enable = true;
        openssh.enable = true;
        tailscale.enable = true;
        sunshine = {
          enable = true;
          autoStart = true;
          capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
          openFirewall = true;
        };
      };

      users.users.khaen = {
        extraGroups = [ "uinput" ];
        openssh.authorizedKeys.keys = [
          # khaen@romulus (for remote Nix builder)
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPpTR9Mon8wapYOEGOcqeCQ4GhMLifGCMZdy18EaeQ4b"
        ];
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
    };
}
