{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    jdk # Java Development Kit.
    scenebuilder # To make Java apps with GUIs using javafx.
  ];
}
