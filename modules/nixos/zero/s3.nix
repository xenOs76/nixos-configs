{
  pkgs,
  config,
  lib,
  ...
}: let
  garage_enable = true;
  garage_data_basedir = "/data/store-btrfs/garage";
  garage_root_domain = "0.os76.xyz";

  garageWebuiAdmin = pkgs.writeScriptBin "garage-webui-admin" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    set -a
    # shellcheck source=/dev/null
    source ${config.sops.templates."garage-env".path}
    set +a

    export API_ADMIN_KEY="''${GARAGE_ADMIN_TOKEN}"
    export API_BASE_URL="''${API_BASE_URL:-http://127.0.0.1:3903}"
    export THEME="Dimm"

    exec ${lib.getExe pkgs.garage-webui}
  '';
in {
  sops.secrets = {
    "garage_rpc_secret" = {};
    "garage_admin_token" = {};
    "garage_metrics_token" = {};
  };

  sops.templates."garage-env" = {
    owner = "root";
    group = "wheel";
    mode = "0440";
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

  systemd.services.garage-dirs = lib.mkIf garage_enable {
    description = "Ensure Garage data directories exist";
    before = ["garage.service"];
    requiredBy = ["garage.service"];
    after = ["data-store-btrfs.mount"];
    unitConfig.RequiresMountsFor = [garage_data_basedir];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScript "garage-dirs" ''
        set -euo pipefail
        ${lib.getExe' pkgs.coreutils "mkdir"} -p \
          ${garage_data_basedir}/data \
          ${garage_data_basedir}/meta
        ${lib.getExe' pkgs.coreutils "chown"} -R garage:garage ${garage_data_basedir}
        ${lib.getExe' pkgs.coreutils "chmod"} 0750 \
          ${garage_data_basedir} \
          ${garage_data_basedir}/data \
          ${garage_data_basedir}/meta
      ''}";
    };
  };

  systemd.services.garage = lib.mkIf garage_enable {
    requires = ["garage-dirs.service"];
    after = ["garage-dirs.service"];
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "garage";
      Group = "garage";
    };
  };

  services = {
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
