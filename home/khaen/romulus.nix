{...}: {
  imports = [
    #
    # ========== Required Configs ==========
    #

    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    #common/optional/desktop
    #common/optional/development
    #common/optional/browser.nix
    #common/optional/mathematica.nix
    common/optional/terminal.nix
  ];
}
