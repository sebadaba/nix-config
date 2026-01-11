{ ... }:
{
  flake.modules.nixos.audio =
    { pkgs, ... }:
    {
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
            package = pkgs.wireplumber;
          };

          pulse.enable = true;
          jack.enable = true;
        };
      };
    };

  flake.modules.homeManager.audio =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pwvucontrol # PipeWire volume control GUI
        qpwgraph # PipeWire patchbay/graph manager
        coppwr # Low level control GUI for PipeWire
      ];
    };
}
