{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    #

    inputs.stylix.nixosModules.stylix

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
  ];
  hostAttr = {
    hostname = "nostromo";
    scheme = config.lib.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";
  };

  time.timeZone = "America/Santiago";

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        devices = ["nodev"];
        useOSProber = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.systemd.enable = true;
  };

  stylix = {
    enable = true;
    image = "${builtins.toString inputs.wallpapers}/sunrise-mountain-416BF.png";
    #base16Scheme = config.hostAttr.scheme;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";
  };

  system.stateVersion = "24.11";

  services = {
    openssh.enable = true;
    tailscale.enable = true;
    actual.enable = true;
  };
}
