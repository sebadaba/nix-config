{
  pkgs,
  ...
}:
let
  renoiseFull = pkgs.renoise.override (oldAttrs: {
    releasePath = /home/khaen/renoise/rns_352_linux_x86_64.tar.gz;
  });
in
{
  home.packages = [
    renoiseFull
  ];
}
