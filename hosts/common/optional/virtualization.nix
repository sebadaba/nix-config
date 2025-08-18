{
  config,
  ...
}:
{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ config.hostSpec.primaryUsername ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
