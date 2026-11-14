{
  inputs,
  ...
}:
{
  flake.modules.nixos.nostromo =
    { ... }:
    {
      imports = [
        (inputs.self.factory."btrfs-subvolumes" {
          primary-disk = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S6S1NS0T908251V";
          swapFileSize = "12G";
        })
        (inputs.self.factory."btrfs-extra-disk" {
          name = "kingston1";
          device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768627359E";
        })
      ];

      services.btrfs.autoScrub.enable = true;

      disko.devices = {
        disk.main.content.partitions.root.content.subvolumes."/games" = {
          mountOptions = [ "compress=zstd" ];
          mountpoint = "/home/khaen/Games";
        };

        disk.kingston1.content.partitions.main.content.subvolumes."/games" = {
          mountOptions = [
            "noatime"
            "nodatacow"
            "nofail"
            "x-systemd.device-timeout=10s"
          ];
          mountpoint = "/mnt/kingston1/games";
        };
      };

      fileSystems = {
        "/mnt/stratego/shared" = {
          device = "100.112.101.73:/Shared";
          fsType = "nfs";
          options = [
            "nfsvers=4.2"
            "x-systemd.automount"
            "noauto"
            "x-systemd.idle-timeout=600"
          ];
        };

        "/mnt/stratego/khaen" = {
          device = "100.112.101.73:/Khaen";
          fsType = "nfs";
          options = [
            "nfsvers=4.2"
            "x-systemd.automount"
            "noauto"
            "x-systemd.idle-timeout=600"
          ];
        };
      };

      # Applied after local-fs.target, so it lands on the mounted subvolume.
      systemd.tmpfiles.rules = [
        "d /home/khaen/Games 0755 khaen users - -"
        "d /mnt/kingston1/games 0755 khaen users - -"
      ];
    };
}
