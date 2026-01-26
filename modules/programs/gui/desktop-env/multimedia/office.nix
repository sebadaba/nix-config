{
  flake.modules.homeManager.office =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        libreoffice
      ];

      xdg.mimeApps.defaultApplications = {
        # Text
        "application/vnd.oasis.opendocument.text" = "writer.desktop"; # .odt
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop"; # .docx
        "application/msword" = "writer.desktop"; # .doc
        # Spreadsheets
        "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop"; # .ods
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop"; # .xlsx
        "application/vnd.ms-excel" = "calc.desktop"; # .xls
        "text/csv" = "calc.desktop"; # .csv
        # Presentations
        "application/vnd.oasis.opendocument.presentation" = "impress.desktop"; # .odp
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "impress.desktop"; # .pptx
        "application/vnd.ms-powerpoint" = "impress.desktop"; # .ppt
      };
    };
}
