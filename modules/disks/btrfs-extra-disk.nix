{
  inputs,
  ...
}:
{
  # Additional disk: standalone btrfs with a single "main" subvolume,
  # mounted at /mnt/<name>. More subvolumes (e.g. "games") can be added later.
  config.flake.factory.btrfs-extra-disk =
    {
      name ? "extra",
      device,
      mountOptions ? [
        "compress=zstd"
        "noatime"
        "nofail"
        "x-systemd.device-timeout=10s"
      ],
    }:
    {
      ...
    }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      disko.devices.disk.${name} = {
        type = "disk";
        device = device;
        content = {
          type = "gpt";
          partitions = {
            main = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/main" = {
                    mountpoint = "/mnt/${name}";
                    inherit mountOptions;
                  };
                };
              };
            };
          };
        };
      };
    };
}
