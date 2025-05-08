{
  pkgs,
  inputs,
  ...
}: let
  nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages.x86_64-linux;
in {
  security.rtkit.enable = true;
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      package = pkgs.pipewire;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      wireplumber = {
        enable = true;
        package = nixpkgs-stable.wireplumber;
      };

      pulse.enable = true;
      jack.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    pwvucontrol # PipeWire volume control GUI
    qpwgraph # PipeWire patchbay/graph manager
    coppwr # Low level control GUI for PipeWire
  ];
}
