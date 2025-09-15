{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.dconf.enable = true;
  #environment.systemPackages = with pkgs; [ gsettings-desktop-schemas ];
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    #    XDG_DATA_DIRS = lib.mkAfter [
    #      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    #      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    #    ]; # qt5 media player problems
  };
}
