{ inputs, ... }:
{
  flake.modules.homeManager.zen =
    { pkgs, lib, ... }:
    {
      home.packages =
        let
          extension = shortId: guid: {
            name = guid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };

          prefs = {
            # Check these out at about:config
            "extensions.autoDisableScopes" = 0;
            "extensions.pocket.enabled" = false;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Necessary for noctalia theming
            # ...
          };

          extensions = [
            # To add additional extensions, find it on addons.mozilla.org, find
            # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
            # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
            (extension "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
            # ...
          ];
        in
        [
          (pkgs.wrapFirefox
            inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
            {
              extraPrefs = lib.concatLines (
                lib.mapAttrsToList (
                  name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
                ) prefs
              );

              extraPolicies = {
                DisableTelemetry = true;
                ExtensionSettings = builtins.listToAttrs extensions;

                SearchEngines = {
                  Default = "ddg";
                  Add = [
                    {
                      Name = "nixpkgs packages";
                      URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                      IconURL = "https://wiki.nixos.org/favicon.ico";
                      Alias = "@np";
                    }
                    {
                      Name = "NixOS options";
                      URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                      IconURL = "https://wiki.nixos.org/favicon.ico";
                      Alias = "@no";
                    }
                    {
                      Name = "NixOS Wiki";
                      URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                      IconURL = "https://wiki.nixos.org/favicon.ico";
                      Alias = "@nw";
                    }

                  ];
                };
              };
            }
          )
        ];
      programs.noctalia.settings.theme.templates.community_ids = [ "zen-browser" ];

      xdg.mimeApps.defaultApplications."text/html" = "zen.desktop"; # Set as default browser
    };
}
