{lib, ...}: let
  inherit (lib) types;

  fontRole =
    {
      name ? "Inter Nerd Font",
      size ? 13,
      sizeDescription,
    }:
    lib.mkOption {
      type = types.submodule {
        options = {
          name = lib.mkOption {
            type = types.str;
            default = name;
            description = "Font family name";
          };
          size = lib.mkOption {
            type = types.int;
            default = size;
            description = sizeDescription;
          };
        };
      };
      default = {};
    };
in {
  options = {
    os76Cfg = {
      gitUserName = lib.mkOption {
        type = types.str;
        default = "Zeno Belli";
        description = "Name of the Git user";
        example = "John Doe";
      };

      gitUserEmail = lib.mkOption {
        type = types.str;
        default = "xeno@os76.xyz";
        description = "Email of the Git user";
        example = "john.doe@example.com";
      };

      gitGpgKeyId = lib.mkOption {
        type = types.str;
        default = "D2D34161F077D9B3";
        description = "ID of the GPG key to use for signing commits";
        example = "123AAABBB456";
      };

      bashPath = lib.mkOption {
        type = types.str;
        default = "$HOME/bin:$HOME/go/bin:$HOME/.krew/bin:$PATH";
        description = "Value of $PATH for the bash shell";
        example = "~/bin:$PATH";
      };

      defKubeNamespace = lib.mkOption {
        type = types.str;
        default = "default";
        description = "Default Kubernetes namespace to switch to on first login";
        example = "istio-system";
      };

      defAwsRegionList = lib.mkOption {
        type = types.listOf types.str;
        default = ["eu-central-1" "eu-west-1" "us-east-1" "garage"];
        description = "Default list of AWS regions to choose from in scripts";
        example = ["eu-central-1"];
      };

      enableFirefox = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Enable Firefox with custom settings and Nur extensions";
        example = false;
      };

      firefoxUseGpu = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable hardware acceleration in Firefox";
        example = false;
      };

      firefoxTrustEnterpriseRoots = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether Firefox trusts OS/Enterprise Root Certificates";
        example = true;
      };

      firefoxAdditionalCertificates = lib.mkOption {
        type = types.listOf types.str;
        default = ["/home/xeno/.config/mkcert/star.home.arpa-RootCA-cert.pem"];
        description = "List of paths to additional Root Certificates for Firefox";
        example = ["./sample-cert.pem"];
      };

      desktopFonts = lib.mkOption {
        type = types.submodule {
          options = {
            ui = fontRole {
              name = "Inter Nerd Font";
              size = 13;
              sizeDescription = "UI font size in points for GTK and Qt";
            };
            mono = fontRole {
              name = "JetBrains Mono";
              size = 13;
              sizeDescription = "Monospace font size in points for GTK and Qt";
            };
            dpi = lib.mkOption {
              type = types.int;
              default = 172;
              description = "X11 font DPI (Xft.dpi) for the desktop environment";
              example = 96;
            };
            cursorSize = lib.mkOption {
              type = types.int;
              default = 16;
              description = "X11 cursor size (Xcursor.size)";
              example = 24;
            };
          };
        };
        default = {};
        description = "Desktop environment font and DPI settings (GTK, Qt, fontconfig, COSMIC)";
      };

      firefoxFonts = lib.mkOption {
        type = types.submodule {
          options = {
            ui = fontRole {
              name = "Inter Nerd Font";
              size = 17;
              sizeDescription = "Proportional page font size in pixels for Firefox";
            };
            mono = fontRole {
              name = "JetBrains Mono";
              size = 17;
              sizeDescription = "Monospace page font size in pixels for Firefox";
            };
          };
        };
        default = {};
        description = "Firefox content font settings in pixels (aligned with desktopFonts via ptToPx)";
      };

      firefoxUseDocumentFonts = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Whether Firefox honors website-specified fonts";
      };

      firefoxMinimumFontSize = lib.mkOption {
        type = types.int;
        default = 0;
        description = "Minimum page font size in pixels for Firefox (0 = disabled)";
      };

      firefoxLangGroup = lib.mkOption {
        type = types.str;
        default = "x-western";
        description = "Firefox font language group suffix for font.* preferences";
        example = "x-unicode";
      };

      checkValue = lib.mkOption {
        type = types.str;
        default = "default value";
        description = "Dummy value to test config propagation";
        example = "imported value";
      };
    };
  };
}
