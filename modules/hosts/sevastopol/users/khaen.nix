{
  inputs,
  ...
}:
{
  flake.modules.nixos.sevastopol =
    { pkgs, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        [
          khaen
        ]
        ++ [ inputs.home-manager.nixosModules.home-manager ];

      home-manager.users.khaen = {
        imports = with inputs.self.modules.homeManager; [
        ];

        home.packages = with pkgs; [
        ];

        home.stateVersion = "25.11";
      };
    };
}
