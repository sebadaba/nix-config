{
  pkgs,
  inputs,
  ...
}:
# now using home-manager module.
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      Cookies = {
        Allow = inputs.nix-secrets.browser.cookies.allowedSites;
      };
      ExtensionSettings = {
        # How to get an extension's GUID:
        # 1) Go to the extension's store page and press F12 (Firefox).
        # 2) Under the "Inspector" tab, in the "Search HTML" field, type "guid" and press enter.
        # 3) Right-click the highlighted <script> tag, then select "Copy" > "Inner HTML".
        # 4) Paste the contents on a JSON formatter like https://jsonlint.com/
        # 5) Search for the GUID field.
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/search_by_image/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
    # Preferences that are not covered by policies.json. See https://librewolf.net/docs/settings/
    autoConfig = ''
      defaultPref("privacy.resistFingerprinting.letterboxing", true);
    '';
  };
}
