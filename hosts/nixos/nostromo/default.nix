{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
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
    ../../common/optional/librewolf.nix
    ../../common/optional/reboot2windows.nix
    ../../common/optional/syncthing.nix
  ];
  hostAttr = {
    hostname = "nostromo";
    scheme = config.lib.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";
  };

  time.timeZone = "America/Santiago";

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
    actual = {
      enable = true;
      openFirewall = true;
    };
  };
}
