{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:
{
  imports = lib.flatten [
    ../../../../modules/common/host-spec.nix
    #../../../../modules/home-manager
    ./git.nix
  ];

  inherit hostSpec;

  #services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault config.hostSpec.primaryUsername;
    homeDirectory = lib.mkDefault "home/${config.hostSpec.primaryUsername}";
    stateVersion = lib.mkDefault "24.11";
    enableNixpkgsReleaseCheck = false;
    sessionVariables = {
    };
  };

  home.packages = with pkgs; [
    spotify
    obs-studio
    anki
    vlc
    bitwarden-desktop
    blender
    libreoffice
    paperwork
    discord-canary
    calibre
    chatbox
    #gimp
    pdftk
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      builders-use-substitutes = true;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
