{
  pkgs,
  inputs,
  ...
}: let
  reboot2windows = pkgs.writeShellScriptBin "reboot2windows" ''
    sudo systemctl reboot --boot-loader-entry=auto-windows
  '';
in {
  environment.systemPackages = [
    reboot2windows
  ];
}
