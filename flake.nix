{
  description = "sebadaba's Nix config flake";

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs outputs;
              isDarwin = false;
            };
            modules = [
              ./hosts/nixos/${host}
              inputs.base16.nixosModule
            ];
          };
        }) (builtins.attrNames (builtins.readDir ./hosts/nixos))
      );

    };

  inputs = {
    #
    # ========= Package Sources =========
    #
    # Default/Main source.
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # This is a source for critical packages that need to be in a stable branch always.
    # This way nixpkgs can be set to the unstable branch to get a jump start
    # on deprecation changes without breaking critical components.
    nixpkgs-stable.url = "nixpkgs/nixos-24.11";
    # Just for packages that need to be bleeding-edge always.
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #
    # ========= Utilities =========
    #
    # Declarative partitioning and formatting.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets management.
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Theming
    base16.url = "github:SenchoPens/base16.nix";
    stylix.url = "github:danth/stylix";

    # Private repos
    nix-secrets = {
      url = "git+ssh://git@github.com/sebadaba/nix-secrets.git?ref=main&shallow=1";
      inputs = { };
    };
    wallpapers = {
      url = "git+ssh://git@github.com/sebadaba/wallpapers.git?ref=main&shallow=1";
      flake = false;
    };
  };
}
