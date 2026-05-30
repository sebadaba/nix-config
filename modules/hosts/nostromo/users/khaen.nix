{
  inputs,
  ...
}:
{
  flake.modules.nixos.nostromo =
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
          productivity
          network-toolkit
        ];

        home.packages = with pkgs; [
          qbittorrent
          chromium
          sonobus
        ];

        home.stateVersion = "26.05";
      };
    };
}
