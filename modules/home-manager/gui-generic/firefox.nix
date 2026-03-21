{
  pkgs,
  config,
  nurpkgs,
  ...
}: {
  #
  # Firefox
  #
  # HM options:
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.enable
  #
  # sample configs:
  #
  # https://github.com/vimjoyer/nix-firefox-video
  # https://github.com/llakala/nixos/tree/3ae839c3b3d5fd4db2b78fa2dbb5ea1080a903cd/apps/programs/firefox
  #
  programs.firefox = {
    enable = config.os76Cfg.enableFirefox;
    languagePacks = [
      "en-US"
    ];

    # https://mozilla.github.io/policy-templates/
    # https://github.com/llakala/nixos/blob/3ae839c3b3d5fd4db2b78fa2dbb5ea1080a903cd/apps/programs/firefox/policies.nix
    policies = {
      DontCheckDefaultBrowser = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "never"; # Previously appeared when pressing alt
      OverrideFirstRunPage = "";
      PictureInPicture.Enabled = false;
      PromptForDownloadLocation = false;
      HardwareAcceleration = config.os76Cfg.firefoxUseGpu;
      TranslateEnabled = true;
      Homepage.StartPage = "previous-session";

      UserMessaging = {
        UrlbarInterventions = false;
        SkipOnboarding = true;
      };

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };

      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };

      # https://mozilla.github.io/policy-templates/#enterprisepoliciesenabled
      # Disables the 'Allow Firefox to automatically trust third-party
      # root certificates you install' checkbox in Settings.
      # macOS only
      EnterprisePoliciesEnabled = config.os76Cfg.firefoxTrustEnterpriseRoots;

      Certificates = {
        # https://mozilla.github.io/policy-templates/#certificates--importenterpriseroots
        # Explicitly forbids the browser from using the OS root certificate store
        ImportEnterpriseRoots = config.os76Cfg.firefoxTrustEnterpriseRoots;

        # https://mozilla.github.io/policy-templates/#certificates--install
        Install = config.os76Cfg.firefoxAdditionalCertificates;
      };
    };

    profiles = {
      "hm-user" = {
        id = 0;
        isDefault = true;
        name = "home-manager managed";
        path = "nix-hm-firefox";

        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.settings
        settings = {
          "security.enterprise_roots.enabled" = config.os76Cfg.firefoxTrustEnterpriseRoots;
          "security.certerrors.mitm.auto_enable_enterprise_roots" = config.os76Cfg.firefoxTrustEnterpriseRoots;

          "extensions.autoDisableScopes" = 0;
          "extensions.update.autoUpdateDefault" = false;
          "extensions.update.enabled" = false;

          # https://hidde.blog/use-firefox-with-a-dark-theme-without-triggering-dark-themes-on-websites/
          "layout.css.prefers-color-scheme.content-override" = 0; # Website appearance: 0 - Dark, 1 - Light, 2 - System

          # https://cleanbrowsing.org/help/docs/configure-dns-over-https-doh-firefox/
          "network.trr.mode" = 3; # DNS over HTTPS: 0 Off (default), 2 Increased Protection, 3 Max Protection, 5 Off (explicit)
          # "network.trr.custom_uri" = ""; # default value
          # "network.trr.default_provider_uri" = "https://mozilla.cloudflare-dns.com/dns-query"; # default value

          # https://wiki.mozilla.org/Trusted_Recursive_Resolver#DNS-over-HTTPS_Prefs_in_Firefox > network.trr.allow-rfc1918
          # (default: false) set this to true to allow RFC 1918 private addresses in TRR responses.
          # When set to false, any such response will be considered invalid and won't be used.
          "network.trr.allow-rfc1918" = true;

          "browser.search.region" = "GB";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";
          "browser.bookmarks.showMobileBookmarks" = true;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.shell.checkDefaultBrowser" = false;
        };

        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions.packages
        # https://nur.nix-community.org/repos/rycee/?query=firefox-addons
        extensions = {
          force = true;
          packages = with nurpkgs.repos.rycee.firefox-addons; [
            ublock-origin
            privacy-badger
            firefox-color
            to-google-translate
            # okta-browser-plugin # non free
            # session-sync
            darkreader
          ];
        };

        search = {
          force = true;
          default = "ddg"; # DuckDuckGo
          privateDefault = "ddg"; # DuckDuckGo
          engines = {
            bing.metaData.hidden = true;
            google.metaData.alias = "@g";
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };

            "Nix Options" = {
              definedAliases = ["@no"];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nw"];
            };
          };
        };
      };
    };
  };
}
