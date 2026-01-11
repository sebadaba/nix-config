{
  flake.modules.nixos.khaen =
    {
      pkgs,
      inputs,
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
      };
      programs.zsh.enable = true;
    };

  flake.modules.homeManager.khaen =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        #...
      ];
      home.username = "khaen";
      home.packages = with pkgs; [
        #...
      ];
    };
}
