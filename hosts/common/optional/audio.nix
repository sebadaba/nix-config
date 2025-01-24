{pkgs, ...}: {
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pwvucontrol # PipeWire volume control GUI
    qpwgraph # PipeWire patchbay/graph manager
    coppwr # Low level control GUI for PipeWire
  ];
}
