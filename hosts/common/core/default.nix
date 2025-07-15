{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../../modules/common
    ../../users/primary
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./sops.nix
  ];

  #
  # ========== Core Host Specifications ==========
  #
  hostSpec = {
    primaryUsername = "khaen";
  };

  time.timeZone = "America/Santiago";

  networking.hostName = config.hostSpec.hostname;
  hardware = {
    enableAllFirmware = true;
    firmware = [ pkgs.linux-firmware ];
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #
  # ========== ==========
  #
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  #
  # ========== Nix ==========
  #
  nix = {
    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      trusted-users = [ "@wheel" ];

      auto-optimise-store = true;
      warn-dirty = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
