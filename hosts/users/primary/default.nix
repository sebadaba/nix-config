{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  hostSpec = config.hostSpec;
in
{
  users.users.${hostSpec.primaryUsername} = {
    name = hostSpec.primaryUsername;
    hashedPasswordFile = config.sops.secrets."users/${hostSpec.primaryUsername}/password".path;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "audio"
    ]
    ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ];
    shell = pkgs.zsh; # default shell
  };

  users.mutableUsers = false;

  # No matter what environment we are in we want these tools
  programs.zsh.enable = true;

  programs.nh = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    sops
    usbutils
    pciutils
    zip
    unzip
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
    };
    users.${hostSpec.primaryUsername}.imports = lib.flatten (
      { config, ... }:
      import ../../../home/${hostSpec.primaryUsername}/${hostSpec.hostname}.nix {
        inherit
          pkgs
          inputs
          config
          lib
          hostSpec
          ;
      }
    );
    backupFileExtension = "backup";
  };
}
