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
  services.openssh.enable = true;

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
    image = /home/${config.hostAttr.primaryUsername}/synced/wallpaper/sunrise-mountain-416BF.png;
    #base16Scheme = config.hostAttr.scheme;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      emoji = {
        package = pkgs.font-awesome;
        name = "Font Awesome";
      };
      sizes = {
        desktop = 14;
        terminal = 14;
        popups = 12;
      };
    };
    opacity = {
      desktop = 0.0;
      terminal = 0.65;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };
  };

  fonts.packages = with pkgs; [(nerdfonts.override {fonts = ["JetBrainsMono"];})];

  system.stateVersion = "24.11";
}
