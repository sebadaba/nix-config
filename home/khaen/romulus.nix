{ ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #

    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/desktop
    common/optional/development
    #common/optional/mathematica.nix
    common/optional/terminal.nix
    common/optional/game-streaming.nix
    common/optional/librewolf.nix
    common/optional/thunderbird.nix
    common/optional/desktop/unredis/packettracer.nix
  ];
}
