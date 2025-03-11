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
    ../../common/optional/hyprland.nix
  ];
  hostAttr = {
    hostname = "romulus";
    scheme = config.lib.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";
  };

  time.timeZone = "America/Santiago";
  services.openssh.enable = true;

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
    image = /home/${config.hostAttr.primaryUsername}/synced/wallpaper/sunrise-mountain-416BF.png;
    #base16Scheme = config.hostAttr.scheme;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";
  };

  system.stateVersion = "24.11";

  # PROVISIONAL
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
