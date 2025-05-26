{
  pkgs,
  inputs,
  ...
}:
# basically same options as programs.firefox
{
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      Cookies = {
        Allow = inputs.nix-secrets.browser.cookies.allowedSites;
      };
    };
    profiles.primary = {
      isDefault = true;
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        darkreader
        bitwarden
        search-by-image
      ];
    };
  };
}
