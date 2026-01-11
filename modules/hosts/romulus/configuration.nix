{
  inputs,
  ...
}:
{
  flake.modules.nixos.romulus = {
    imports =
      with inputs.self.modules.nixos;
      [
        audio
        plymouth
        #...
      ]
      ++ [ inputs.self.modules.generic.constants ];

    services = {
      openssh.enable = true;
      tailscale.enable = true;
    };

    networking = {
      hostName = "romulus";
      networkmanager.enable = true;
    };

    system.stateVersion = "24.11";
  };
}
