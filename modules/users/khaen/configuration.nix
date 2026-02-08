{ inputs, ... }:
{
  flake.modules.nixos.khaen =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        # ...
      ];

      home-manager.users.khaen = {
        imports = [
          inputs.self.modules.homeManager.khaen

        ];
      };

      users.users.khaen = {
        isNormalUser = true;
        initialPassword = "changeme";
        shell = pkgs.zsh;
        extraGroups = [ "wheel" ];
      };
      programs.zsh.enable = true;
    };

  flake.modules.homeManager.khaen =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        shell
        development
        #...
      ];
      home.username = "khaen";
      home.packages = with pkgs; [
        #...
      ];
    };
}
