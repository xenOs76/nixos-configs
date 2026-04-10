{lib, ...}: {
  options = {
    os76Cfg = {
      gitUserName = lib.mkOption {
        type = lib.types.str;
        default = "Zeno Belli";
        description = "Name of the Git user";
        example = "John Doe";
      };

      gitUserEmail = lib.mkOption {
        type = lib.types.str;
        default = "xeno@os76.xyz";
        description = "Email of the Git user";
        example = "john.doe@example.com";
      };

      bashPath = lib.mkOption {
        type = lib.types.str;
        default = "$HOME/bin:$HOME/go/bin:$PATH";
        description = "Value of $PATH for the bash shell";
        example = "~/bin:$PATH";
      };

      defKubeNamespace = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = "Default Kubernetes namespace to switch to on first login";
        example = "istio-system";
      };

      defAwsRegionList = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["eu-central-1" "eu-west-1" "us-east-1"];
        description = "Default list of AWS regions to choose from in scripts";
        example = ["eu-central-1"];
      };

      enableFirefox = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Firefox with custom settings and Nur extensions";
        example = false;
      };

      firefoxUseGpu = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable hardware acceleration in Firefox";
        example = false;
      };

      firefoxTrustEnterpriseRoots = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Firefox trusts OS/Enterprise Root Certificates";
        example = true;
      };

      firefoxAdditionalCertificates = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of paths to additional Root Certificates for Firefox";
        example = ["./sample-cert.pem"];
      };

      checkValue = lib.mkOption {
        type = lib.types.str;
        default = "default value";
        description = "Dummy value to test config propagation";
        example = "imported value";
      };
    };
  };
}
