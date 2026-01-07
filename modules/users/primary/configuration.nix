{
  inputs,
  config,
  ...
}:

let
  username = config.constants.primary-user.name;
in

{
  flake.modules.nixos."${username}" =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        # ...
      ];

      home-manager.users."${username}" = {
        imports = [
          inputs.self.modules.homeManager."${username}"
        ];
      };

      users.users."${username}" = {
        isNormalUser = true;
        initialPassword = "changeme";
        shell = pkgs.zsh;
      };
      programs.zsh.enable = true;
    };

  flake.modules.homeManager."${username}" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        #...
      ];
      home.username = "${username}";
      home.packages = with pkgs; [
        #...
      ];
    };
}
