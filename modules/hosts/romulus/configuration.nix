{
  inputs,
  ...
}:
{
  flake.modules.nixos.romulus =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        basic-system
        audio
        plymouth
        desktop-env
        #...
      ];

      services = {
        tuned.enable = true;
        upower.enable = true;
        thinkfan.enable = true;
        openssh.enable = true;
        tailscale.enable = true;
      };

      # Send builds to nostromo when reachable; the local daemon is always
      # kept available, so if nostromo is unreachable Nix falls back to
      # building locally automatically.
      nix = {
        distributedBuilds = true;
        buildMachines = [
          {
            hostName = "nostromo.tail004be.ts.net";
            sshUser = "khaen";
            sshKey = "/home/khaen/.ssh/id_ed25519";
            system = "x86_64-linux";
            maxJobs = 12;
            speedFactor = 2;
            protocol = "ssh-ng";
          }
        ];
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
        enableAllFirmware = true;
        #enableRedistributableFirmware = true;
        firmware = [ pkgs.linux-firmware ];
      };

      hardware.facter.reportPath = ./facter.json;

      nixpkgs.config.allowUnfree = true;

    };
}
