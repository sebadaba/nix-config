{
  inputs,
  config,
  ...
}:
let
  username = config.constants.primary-user.name;
in
{
  flake.modules.nixos.romulus = {
    imports = with inputs.self.modules.nixos; [
      "${username}"
    ];

    home-manager.users."${username}" = {
      #...
    };
  };
}
