{
  flake.modules.homeManager.network-toolkit =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        minicom # Serial connectivity
        expect # Scripting for interactive programs
        iperf # Network performance measurement
      ];
    };
}
