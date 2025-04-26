{ config, pkgs, user, inputs, system, ... }:
{
  programs.firefox = {
    enable = true;
    #languagePacks = [ "en-US" ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified";
    };
    profiles.${user.name} = {
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
      };
      search.force = true;

      settings = {
        "accessibility.typeaheadfind.flashBar" = 0;
        "browser.contentblocking.category" = "standard";
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.download.panel.shown" = true;
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "dom.security.https_only_mode" = true;
        "findbar.highlightAll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        /* Hide tab bar in FF */
        #TabsToolbar {
          visibility: collapse !important;
        }
        /* hides the title bar */
        #titlebar {
          visibility: collapse;
        }
        
        /* hides the sidebar */
        #sidebar-header {
          visibility: collapse !important;
        }
      '';

      extensions.packages = with inputs.firefox-addons.packages.${system}; [
        onepassword-password-manager
        tampermonkey
        tree-style-tab
        ublock-origin
      ];
    };
  };
}
