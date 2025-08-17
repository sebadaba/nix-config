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
        github.copilot # Copilot
        github.copilot-chat # Copilot chat
      ];
      userSettings = {
        "window.titleBarStyle" = lib.mkIf config.wayland.windowManager.hyprland.enable "custom"; # Avoids crash on startup on Hyprland.
        "workbench.iconTheme" = "vscode-icons";

        # Editor
        "editor.tabSize" = 4; # Size of 1 tab == Size of 4 spaces.
        "editor.insertSpaces" = false; # Insert a tab character, not a couple of spaces.
        "editor.detectIndentation" = true; # If a file has another format, stick with it.
        "editor.formatOnSave" = true;

        # Nix
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
      extensions =
        with pkgs.vscode-extensions;
        profiles.Base.extensions
        ++ [
          redhat.java # Java syntax highlight
        ];
      userSettings = profiles.Base.userSettings;
    };
    Web = {
      extensions =
        with pkgs.vscode-extensions;
        profiles.Base.extensions
        ++ [
          vue.volar
          #devsense.phptools-vscode
        ];
      userSettings = profiles.Base.userSettings;
    };
    Cpp = {
      extensions =
        with pkgs.vscode-extensions;
        profiles.Base.extensions
        ++ [
          ms-vscode.cpptools
        ];
      userSettings = profiles.Base.userSettings;
    };
  };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
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
