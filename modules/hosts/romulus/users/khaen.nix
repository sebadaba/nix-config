{
  inputs,
  ...
}:
{
  flake.modules.nixos.romulus =
    { pkgs, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        [
          khaen
        ]
        ++ [ inputs.home-manager.nixosModules.home-manager ];

      home-manager.users.khaen = {
        # Specific config for khaen on romulus
        home.packages = with pkgs; [
          satdump
          sdrpp
        ];
        home.stateVersion = "24.11";
      };
    };
}
