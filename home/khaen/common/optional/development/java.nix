{
  pkgs,
  ...
}:
{
  programs.java = {
    enable = true;
    package = pkgs.jdk21.override {
      enableJavaFX = true;
      openjfx_jdk = pkgs.javaPackages.openjfx23;
    };
  };

  home.packages = with pkgs; [
    scenebuilder # Gluon Scenebuilder
    maven
  ];
  ## Drag and drop issue for Scenebuilder on Hyprland fix
  wayland.windowManager.hyprland.settings.windowrule = [
    "stayfocused,class:com.oracle.javafx.scenebuilder.app.SceneBuilderApp"
  ];
}
