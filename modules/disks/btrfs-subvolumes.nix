{
  inputs,
  ...
}:
{
  config.flake.factory.btrfs-subvolumes =
    {
      primary-disk ? "/dev/disk/by-diskseq/1",
      swapFileSize ? "2G",
    }:
    {
      ...
    }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      disko.devices = {
        disk = {
          main = {
            type = "disk";
            device = primary-disk;
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  priority = 1;
                  name = "ESP";
                  start = "1M";
                  end = "512M";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "umask=0077" ];
                  };
                };
                root = {
                  name = "btrfs-root";
                  size = "100%";
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ]; # Override existing partition
                    mountpoint = "/partition-root"; # To manage subvolumes if needed
                    # Subvolumes must set a mountpoint in order to be mounted,
                    # unless their parent is mounted
                    subvolumes = {
                      # Subvolume name is different from mountpoint
                      "/root" = {
                        mountpoint = "/";
                      };
                      # Subvolume name is the same as the mountpoint
                      "/home" = {
                        mountOptions = [ "compress=zstd" ];
                        mountpoint = "/home";
                      };

                      "/nix" = {
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                        mountpoint = "/nix";
                      };

                      # Subvolume for the swapfile
                      "/swap" = {
                        mountpoint = "/.swapvol";
                        swap = {
                          swapfile.size = swapFileSize;
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
}
