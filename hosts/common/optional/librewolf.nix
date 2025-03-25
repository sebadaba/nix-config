{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      ExtensionSettings = {
        # How to get an extension's GUID:
        # 1) Go to the extension's store page and press F12 (Firefox).
        # 2) Under the "Inspector" tab, in the "Search HTML" field, type "guid" and press enter.
        # 3) Right-click the highlighted <script> tag, then select "Copy" > "Inner HTML".
        # 4) Paste the contents on a JSON formatter like https://jsonlint.com/
        # 5) Get the GUID from line 28.
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
