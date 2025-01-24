{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./c.nix
    ./java.nix
    ./python.nix
    ./vscode.nix
  ];
}
