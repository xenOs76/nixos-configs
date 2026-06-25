{
  pkgs,
  config,
  lib,
  ...
}: let
  minio_enable = true;
  minio_root_credentials_file = "/etc/minio-root-credentials";

  garage_enable = true;
  garage_data_basedir = "/data/store-btrfs/garage";
  garage_root_domain = "0.os76.xyz";

  garageWebuiAdmin = pkgs.writeScriptBin "garage-webui-admin" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    if [[ "$(id -u)" -ne 0 ]]; then
      echo "garage-webui-admin: must be run as root (e.g. sudo garage-webui-admin)" >&2
      exit 1
    fi

    set -a
    # shellcheck source=/dev/null
    source ${config.sops.templates."garage-env".path}
    set +a

    export API_ADMIN_KEY="''${GARAGE_ADMIN_TOKEN}"
    export API_BASE_URL="''${API_BASE_URL:-http://127.0.0.1:3903}"

    exec ${lib.getExe pkgs.garage-webui}
  '';
in {
  sops.secrets = {
    "minio_root_credentials" = {
      owner = "minio";
      path = minio_root_credentials_file;
    };
    "garage_rpc_secret" = {};
    "garage_admin_token" = {};
    "garage_metrics_token" = {};
  };

  sops.templates."garage-env" = {
    owner = "root";
    mode = "0400";
    content = ''
      GARAGE_RPC_SECRET="${config.sops.placeholder.garage_rpc_secret}"
      GARAGE_ADMIN_TOKEN="${config.sops.placeholder.garage_admin_token}"
      GARAGE_METRICS_TOKEN="${config.sops.placeholder.garage_metrics_token}"
    '';
  };

  environment.systemPackages = lib.optionals garage_enable [
    garageWebuiAdmin
  ];

  users.groups.garage = {};
  users.users.garage = {
    isSystemUser = true;
    group = "garage";
    home = "/var/empty";
  };

  systemd.services.garage = lib.mkIf garage_enable {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "garage";
      Group = "garage";
    };
  };

  systemd.tmpfiles.rules = lib.mkIf garage_enable [
    "d ${garage_data_basedir} 0750 garage garage -"
    "Z ${garage_data_basedir} - garage garage -"
  ];

  services = {
    #
    # Minio
    #
    minio = {
      enable = minio_enable;
      region = "zero";
      rootCredentialsFile = minio_root_credentials_file;
      dataDir = ["/data/store-btrfs/minio/data"];
      listenAddress = "127.0.0.1:9000";
      consoleAddress = "127.0.0.1:9001";
    };

    #
    # Garage
    #
    garage = {
      enable = garage_enable;
      package = pkgs.garage_2;
      environmentFile = config.sops.templates."garage-env".path;
      settings = {
        data_dir = "${garage_data_basedir}/data";
        metadata_dir = "${garage_data_basedir}/meta";
        db_engine = "sqlite";

        replication_factor = 1;

        rpc_bind_addr = "[::]:3901";
        rpc_public_addr = "127.0.0.1:3901";

        s3_api = {
          s3_region = "garage";
          api_bind_addr = "[::]:3900";
          root_domain = ".garage-s3.${garage_root_domain}";
        };

        s3_web = {
          bind_addr = "[::]:3902";
          root_domain = ".garage-web.${garage_root_domain}";
          index = "index.html";
        };

        admin = {
          api_bind_addr = "[::]:3903";
        };
      };
    };
  };
}
