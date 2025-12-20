{
  pkgs,
  ...
}:
{
  programs.java = {
    enable = true;
    package = pkgs.jdk25.override {
      enableJavaFX = true;
      openjfx_jdk = pkgs.javaPackages.openjfx25;
    };
  };

  home.packages = with pkgs; [
    #scenebuilder # Gluon Scenebuilder
    maven
  ];
  ## Drag and drop issue for Scenebuilder on Hyprland fix
  wayland.windowManager.hyprland.settings.windowrule = [
    "stayfocused,class:com.oracle.javafx.scenebuilder.app.SceneBuilderApp"
  ];
}
