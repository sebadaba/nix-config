{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ thunderbird ];
  /*
    programs.thunderbird = {
      enable = true;
      profiles = {
      };
    }; # not for now lol
  */
}
