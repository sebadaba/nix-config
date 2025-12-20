{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (python3.withPackages (
      ps:
      with ps;
      with python3Packages;
      [
        # for jupyter notebooks
        jupyter
        ipython

        # general
        pandas
        numpy
        matplotlib

        # other
        pymongo
      ]
    ))
  ];
}
