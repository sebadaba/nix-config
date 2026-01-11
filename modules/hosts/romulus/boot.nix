{
  flake.modules.nixos.romulus = {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          consoleMode = "2";
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/efi";
        };
      };

      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [
        "kvm-amd"
        # get wifi drivers to work for Realtek Wifi RTL8852CE (problems persist but better than nothing I guess)
        "rtw89_8852ce"
      ];
    };
  };
}
