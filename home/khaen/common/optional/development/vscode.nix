{
  pkgs,
  config,
  lib,
  ...
}:
let
  profiles = {
    Base = {
      extensions = with pkgs.vscode-extensions; [
        esbenp.prettier-vscode # General formatter
        adpyke.codesnap # Nice screenshots
        vscode-icons-team.vscode-icons # Better icons
        jnoortheen.nix-ide # Nix syntax highlight,  formatting..
        mechatroner.rainbow-csv # CSV colors
      ];
      userSettings = {
        "editor.formatOnSave" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
          };
        };
      };
    };
    Java = lib.mkIf config.programs.java.enable {
      extensions = with pkgs.vscode-extensions; profiles.Base.extensions ++ [ vscjava.vscode-java-pack ];
    };
  };
in
{
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
    profiles = profiles;
  };
  home.packages = with pkgs; [
    nixfmt-rfc-style # Nix formatter
    nixd # Nix language server
    sublime-merge
  ];
  stylix.targets.vscode.profileNames = builtins.attrNames profiles;
}
