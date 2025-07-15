{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gcc # GNU Compiler Collection
    gdb # GNU Debugger
    gnumake # GNU's Make
    valgrind
    qtcreator
    libsForQt5.full
    jetbrains.clion
  ];
}
