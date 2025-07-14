{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
# basically same options as programs.firefox
{
  programs.librewolf = {
    enable = true;
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
      settings = {
        "privacy.resistFingerprinting.letterboxing" = true;
      };
      search.engines = {
        nixpkgs = {
          name = "Nixpkgs search";
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        hm-options = {
          name = "Home-Manager options search";
          urls = [
            {
              template = "https://home-manager-options.extranix.com/";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@hm" ];
        };
      };
    };
  };
  stylix.targets.librewolf.profileNames = [ "primary" ];

  # https://github.com/nix-community/home-manager/issues/4199#issuecomment-2683440129
  home.activation.removeBrowserBackups = lib.hm.dag.entryAfter [ "checkLinkTargets" ] ''
    	if [ -d "${config.home.homeDirectory}/.librewolf/primary" ]; then
    		rm -f ${config.home.homeDirectory}/.librewolf/primary/search.json.mozlz4.backup
    	fi
  '';
}
