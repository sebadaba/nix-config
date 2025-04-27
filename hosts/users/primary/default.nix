{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  hostAttr = config.hostAttr;
in {
  users.users.${hostAttr.primaryUsername} = {
    name = hostAttr.primaryUsername;
    hashedPasswordFile = config.sops.secrets."users/${hostAttr.primaryUsername}/password".path;
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "audio"];
    shell = pkgs.zsh; # default shell
  };

  users.mutableUsers = false;

  # No matter what environment we are in we want these tools
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    sops
    usbutils
    pciutils
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostAttr = config.hostAttr;
    };
    users.${hostAttr.primaryUsername}.imports = lib.flatten (
      {config, ...}:
        import
        ../../../home/${hostAttr.primaryUsername}/${hostAttr.hostname}.nix {
          inherit
            pkgs
            inputs
            config
            lib
            hostAttr
            ;
        }
    );
    backupFileExtension = "backup";
  };
}
