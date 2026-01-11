{
  inputs,
  ...
}:
{
  flake.modules.nixos.romulus = {
    imports = with inputs.self.modules.nixos; [
      khaen
    ];

    home-manager.users.khaen = {
      # Specific config for khaen on romulus
    };
  };
}
