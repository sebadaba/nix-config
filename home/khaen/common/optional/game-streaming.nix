{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      moonlight-qt
      sonobus
    ];
  };
}
