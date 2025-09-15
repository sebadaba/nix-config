{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    moonlight-qt
    #sonobus # depends on webkitgtk_4_0, not built by hydra anymore and insecure because of libsoup2.
  ];
}
