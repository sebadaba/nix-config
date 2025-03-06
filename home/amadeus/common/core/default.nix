{
  config,
  lib,
  pkgs,
  hostAttr,
  ...
}: {
  imports = lib.flatten [
    ../../../../modules/common/host-attr.nix
    #../../../../modules/home-manager
    ./git.nix
  ];

  inherit hostAttr;

  #services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault config.hostAttr.primaryUsername;
    homeDirectory = lib.mkDefault "home/${config.hostAttr.primaryUsername}";
    stateVersion = lib.mkDefault "24.11";
    sessionVariables = {
    };
  };

  home.packages = with pkgs; [
    spotify
    obs-studio
    anki
    vlc
    bitwarden
    blender
    vesktop
    libreoffice
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
