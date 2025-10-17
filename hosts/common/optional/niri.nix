{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];
  #nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri = {
    enable = if config.hostSpec.wlCompositor == "Niri" then true else false;
    package = pkgs.niri;
  };
  services.dbus.packages = [ pkgs.nautilus ];
  services.gvfs.enable = true;
}
