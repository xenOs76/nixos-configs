{
  config,
  lib,
  ...
}: let
  cfg = config.os76.nix.binaryCache;
  cachePort = 5080;
  defaultCacheUrl = "http://zero.home.arpa:${toString cachePort}";
  defaultPublicKey = "zero.home.arpa-1:JHBS22StZ57jV0AQjwhH8lMxKUby6SU8J+dRMEIwNWM=";
in {
  options.os76.nix.binaryCache = {
    server = {
      enable = lib.mkEnableOption "Harmonia binary cache server for the local Nix store";

      port = lib.mkOption {
        type = lib.types.port;
        default = cachePort;
        description = "Port for Harmonia to listen on (5080 avoids docker-registry on 5000)";
      };
    };

    client = {
      enable = lib.mkEnableOption "Use a remote Harmonia binary cache as a Nix substituter";

      url = lib.mkOption {
        type = lib.types.str;
        default = defaultCacheUrl;
        description = "Binary cache URL";
      };

      publicKey = lib.mkOption {
        type = lib.types.str;
        default = defaultPublicKey;
        description = "Trusted public key for the binary cache";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.server.enable {
      sops.secrets.harmonia_sign_key = {
        mode = "0400";
        owner = "root";
      };

      services.harmonia = {
        enable = true;
        signKeyPaths = [config.sops.secrets.harmonia_sign_key.path];
        settings = {
          bind = "[::]:${toString cfg.server.port}";
        };
      };
    })
    (lib.mkIf cfg.client.enable {
      nix.settings.substituters = lib.mkBefore [cfg.client.url];
      nix.settings.trusted-public-keys = lib.mkBefore [cfg.client.publicKey];
    })
  ];
}
