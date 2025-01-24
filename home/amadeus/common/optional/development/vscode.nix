{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    programs.vscode = {
      enable = true;
      userSettings = {
        "window.titleBarStyle" = "custom"; # Avoids crash on startup on Hyprland.
        # Tabs
        "editor.tabSize" = 4; # Size of 1 tab == Size of 4 spaces.
        "editor.insertSpaces" = false; # Insert a tab character, not a couple of spaces.
        "editor.detectIndentation" = true; # If a file has another format, stick with it.
      };
      mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        kamadorueda.alejandra
        mechatroner.rainbow-csv
        ms-vscode.cpptools
        ms-python.python
        ms-vscode.makefile-tools
      ];
    };
    home.packages = with pkgs; [
      alejandra # Nix formatter.
      sublime-merge
    ];
  };
}
