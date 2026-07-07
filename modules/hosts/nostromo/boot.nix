{
  flake.modules.nixos.nostromo = {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          consoleMode = "2";
        };
        efi = {
          canTouchEfiVariables = true;
          #efiSysMountPoint = "/efi";
        };
      };

      kernelModules = [
        # ...
      ];
    };
  };
}
