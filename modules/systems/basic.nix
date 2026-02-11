{ inputs, ... }:
{
  flake.modules.nixos.basic-system = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    imports = [ inputs.self.modules.generic.constants ];

    time.timeZone = "America/Santiago";
  };
}
