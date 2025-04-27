{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.java = {
    enable = true;
    package =
      pkgs.jdk21.override
      {
        enableJavaFX = true;
        openjfx_jdk = pkgs.javaPackages.openjfx21;
      };
  };
  home.packages = with pkgs; [scenebuilder];
}
