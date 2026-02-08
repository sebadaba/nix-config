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
        imports = with inputs.self.modules.homeManager; [ vesktop ];
        # Specific config for khaen on romulus
        home.packages = with pkgs; [
          satdump
          sdrpp
          moonlight-qt
        ];

        home.stateVersion = "24.11";
      };
    };
}
