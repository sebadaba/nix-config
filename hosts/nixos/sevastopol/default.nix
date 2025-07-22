{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    #
    # ========== Hardware ==========
    #
    #./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    (import ../../common/disks/btrfs-subvolumes.nix {
      disk = "/dev/nvme0n1";
      swapSize = "6G";
    })
    #
    # ========== Required Configs ==========
    #
    ../../common/core

    #
    # ========== Optional Configs ==========
    #
    ../../common/optional/audio.nix
    ../../common/optional/greetd.nix
    ../../common/optional/hyprland.nix
    ../../common/optional/syncthing.nix
  ];
  hostSpec = {
    hostname = "sevastopol";
    scheme = config.lib.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        xbootldrMountPoint = "/boot";
        consoleMode = "2";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };

  system.stateVersion = "24.11";

  services = {
    openssh.enable = true;
    actual = {
      enable = true;
      openFirewall = true;
    };
  };
  #temp
  nixpkgs.hostPlatform = "x86_64-linux";
}
