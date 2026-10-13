{
  flake.modules.homeManager.office =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        onlyoffice-desktopeditors
      ];

      xdg.mimeApps.defaultApplications = {
        # Text
        "application/vnd.oasis.opendocument.text" = "onlyoffice-desktopeditors.desktop"; # .odt
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
          "onlyoffice-desktopeditors.desktop"; # .docx
        "application/msword" = "onlyoffice-desktopeditors.desktop"; # .doc
        # Spreadsheets
        "application/vnd.oasis.opendocument.spreadsheet" = "onlyoffice-desktopeditors.desktop"; # .ods
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =
          "onlyoffice-desktopeditors.desktop"; # .xlsx
        "application/vnd.ms-excel" = "onlyoffice-desktopeditors.desktop"; # .xls
        "text/csv" = "onlyoffice-desktopeditors.desktop"; # .csv
        # Presentations
        "application/vnd.oasis.opendocument.presentation" = "onlyoffice-desktopeditors.desktop"; # .odp
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
          "onlyoffice-desktopeditors.desktop"; # .pptx
        "application/vnd.ms-powerpoint" = "onlyoffice-desktopeditors.desktop"; # .ppt
      };
    };
}
