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
          android-studio
        ]
        ++ [ inputs.home-manager.nixosModules.home-manager ];

      home-manager.users.khaen = {
        imports = with inputs.self.modules.homeManager; [
          zed
          zen
          development
          vesktop
          spicetify
        ];
        # Specific config for khaen on romulus
        home.packages = with pkgs; [
          satdump
          sdrpp
          moonlight-qt
          qbittorrent
          chromium
          sonobus
        ];

        home.stateVersion = "24.11";
      };
    };
}
