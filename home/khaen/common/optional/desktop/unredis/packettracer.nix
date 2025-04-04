{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    home.packages = with pkgs; [ciscoPacketTracer8];
    wayland.windowManager.hyprland.settings.windowrulev2 = lib.mkIf config.wayland.windowManager.hyprland.enable [
      "float, initialClass:PacketTracer, initialTitle:negative:Cisco Packet Tracer"
    ];
  };
}
