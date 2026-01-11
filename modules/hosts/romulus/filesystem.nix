{
  flake.modules.nixos.romulus = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/76e7d2f2-313f-451c-9f72-faa4af762b81";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/019D-417B";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      "/efi" = {
        device = "/dev/disk/by-uuid/D8FB-6E99";
        fsType = "vfat";
      };
    };
  };
}
