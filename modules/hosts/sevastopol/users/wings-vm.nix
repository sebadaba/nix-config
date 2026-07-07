{
  ...
}:
{
  flake.modules.nixos.sevastopol = {
    users.users.wings-vm = {
      isSystemUser = true;
      group = "wings-vm";
      description = "User that runs a VM with wings-agent";
      extraGroups = [
        "libvirtd"
        "kvm"
      ];
      home = "/var/lib/wings-vm";
    };
    users.groups.wings-vm = { };
  };
}
