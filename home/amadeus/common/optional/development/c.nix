{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    gcc # GNU Compiler Collection
    gdb # GNU Debugger
    gnumake # GNU's Make
    valgrind
  ];
}
