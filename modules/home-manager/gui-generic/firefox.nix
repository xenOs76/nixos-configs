{
  pkgs,
  config,
  nurpkgs,
  lib,
  ...
}:
let
  firefoxProfileName = "firefox";

  k8sIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.svg";
    sha256 = "1gz6c47fv7jm3s3ij9qkrv2x05hvs5x71bmmwkpb13jq3swc7xm8";
  };

  goIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/golang/vscode-go/refs/heads/master/extension/media/go-logo-blue.png";
    sha256 = "0yjsplshj6bgzvizj4snj2r168py48iz6w9hwf3mq6vjqw8fvmyc";
  };

  lang = config.os76Cfg.firefoxLangGroup;
  ffUi = config.os76Cfg.firefoxFonts.ui;
  ffMono = config.os76Cfg.firefoxFonts.mono;

  fontSettings = {
    "font.name.sans-serif.${lang}" = ffUi.name;
    "font.name.serif.${lang}" = ffUi.name;
    "font.name.monospace.${lang}" = ffMono.name;
    "font.size.variable.${lang}" = ffUi.size;
    "font.size.monospace.${lang}" = ffMono.size;
    "font.size.serif.${lang}" = 0;
    "font.size.sans-serif.${lang}" = 0;
    "font.minimum-size.${lang}" = config.os76Cfg.firefoxMinimumFontSize;
    "browser.display.use_document_fonts" = if config.os76Cfg.firefoxUseDocumentFonts then 1 else 0;
  };
in
{
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
    # Explicit XDG path: Firefox 152 still prefers ~/.mozilla/firefox when it exists.
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    languagePacks = [
      "en-US"
    ];

    # https://firefox-admin-docs.mozilla.org/reference/policies/
    # https://mozilla.github.io/policy-templates/
    # https://nix-community.github.io/home-manager/options/home-manager/programs/firefox.html#opt-programs.firefox.policies
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

      GenerativeAI = {
        Enabled = false;
        Chatbot = false;
        LinkPreviews = false;
        TabGroups = false;
        Locked = true;
      };

      Sync = {
        Addons = true;
        Addresses = true;
        Bookmarks = true;
        Enabled = true;
        History = true;
        Locked = true;
        OpenTabs = false;
        Passwords = false;
        PaymentMethods = false;
        Settings = true;
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
        name = firefoxProfileName;
        path = firefoxProfileName;

        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.settings
        settings = {
          "security.enterprise_roots.enabled" = config.os76Cfg.firefoxTrustEnterpriseRoots;
          "security.certerrors.mitm.auto_enable_enterprise_roots" =
            config.os76Cfg.firefoxTrustEnterpriseRoots;

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
        }
        // fontSettings;

        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions.packages
        # https://nur.nix-community.org/repos/rycee/?query=firefox-addons
        extensions = {
          force = true;
          packages = with nurpkgs.repos.rycee.firefox-addons; [
            # session-sync
            bitwarden
            browserpass
            darkreader
            firefox-color
            privacy-badger
            to-google-translate
            ublock-origin
          ];
        };

        search = {
          force = true;
          default = "g"; # Google
          privateDefault = "ddg"; # DuckDuckGo
          engines = {
            bing.metaData.hidden = true;
            ebay.metaData.hidden = true;
            perplexity.metaData.hidden = true;
            wikipedia.metaData.hidden = true;
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
              definedAliases = [ "@np" ];
            };

            "Nix Options" = {
              definedAliases = [ "@no" ];
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
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };

            "Kubernetes Docs" = {
              urls = [
                {
                  template = "https://kubernetes.io/search/";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${k8sIcon}";
              definedAliases = [ "@k" ];
            };

            "Go Docs" = {
              urls = [
                {
                  template = "https://pkg.go.dev/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${goIcon}";
              definedAliases = [ "@go" ];
            };
          };
        };
      };
    };
  };

  # Firefox cannot update a read-only store-linked profiles.ini on launch.
  # https://github.com/nix-community/home-manager/issues/3117
  home.file."${config.xdg.configHome}/mozilla/firefox/profiles.ini" =
    lib.mkIf config.os76Cfg.enableFirefox
      {
        force = true;
      };

  # Stock Firefox looks in ~/.mozilla/firefox; keep the real profile under XDG.
  home.file.".mozilla/firefox" = lib.mkIf config.os76Cfg.enableFirefox {
    source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/mozilla/firefox";
  };

  xdg.mimeApps = lib.mkIf config.os76Cfg.enableFirefox {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
    associations.removed = {
      "text/html" = [ "chromium-browser.desktop" ];
      "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
      "x-scheme-handler/https" = [ "chromium-browser.desktop" ];
    };
  };

  xdg.configFile = lib.mkIf config.os76Cfg.enableFirefox {
    "mimeapps.list".force = true;
    # COSMIC reads this file for link opens; keep it aligned with mimeapps.list.
    "cosmic-mimeapps.list" = {
      force = true;
      text = ''
        [Default Applications]
        text/html=firefox.desktop
        x-scheme-handler/http=firefox.desktop
        x-scheme-handler/https=firefox.desktop
      '';
    };
  };

  home.activation = lib.mkIf config.os76Cfg.enableFirefox {
    firefoxProfilesIniBackupCleanup = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      $DRY_RUN_CMD rm -f "${config.xdg.configHome}/mozilla/firefox/profiles.ini.backup"
    '';

    firefoxWritableProfilesIni = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      profileDir="${config.xdg.configHome}/mozilla/firefox"
      profilesIni="$profileDir/profiles.ini"
      if [ -L "$profilesIni" ]; then
        $DRY_RUN_CMD cp -fL "$profilesIni" "$profilesIni.hm-tmp"
        $DRY_RUN_CMD rm -f "$profilesIni"
        $DRY_RUN_CMD mv "$profilesIni.hm-tmp" "$profilesIni"
        $DRY_RUN_CMD chmod u+w "$profilesIni"
      elif [ -f "$profilesIni" ] && [ ! -w "$profilesIni" ]; then
        $DRY_RUN_CMD chmod u+w "$profilesIni"
      fi
    '';
  };
}
