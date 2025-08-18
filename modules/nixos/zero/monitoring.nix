{
  pkgs,
  config,
  ...
}:
let
  minio_root_credentials_file = "/etc/minio-root-credentials";
in
{
  networking.firewall.allowedTCPPorts = [
    9100 # node-exporter
    3200 # Grafana Tempo
    4317 # Grafana Tempo
    4318 # Grafana Tempo
    2181 # kafka zookeeper
    9092 # kafka listener
    9308 # kafka exporter
  ];

  sops.secrets = {
    "grafana_db_user" = {
      owner = "grafana";
    };
    "grafana_db_pass" = {
      owner = "grafana";
    };
    "grafana_auth_client_id" = {
      owner = "grafana";
    };
    "grafana_auth_client_secret" = {
      owner = "grafana";
    };
    "minio_root_credentials" = {
      owner = "minio";
      path = minio_root_credentials_file;
    };
    "tempo_minio_bucket_name" = { };
    "tempo_minio_access_key" = { };
    "tempo_minio_secret_key" = { };
  };

  #
  # Grafana
  #
  systemd.services.grafana.wants = [ "network-online.target" ];
  systemd.services.grafana.after = [ "network-online.target" ];

  # Grafana file provider:
  # https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider
  services.grafana = {
    enable = true;
    # dataDir = "/data/grafana/data";
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "grafana.0.0s76.xyz";
        root_url = "https://grafana.0.os76.xyz";
        serve_from_sub_path = false;
      };
      security = {
        admin_user = "admin";
        admin_password = "admin";
        admin_email = "xeno@os76.xyz";
      };
      database = {
        name = "grafana";
        user = "$__file{${config.sops.secrets."grafana_db_user".path}}";
        password = "$__file{${config.sops.secrets."grafana_db_pass".path}}";
        host = "192.168.1.8";
        type = "mysql";
        ssl_mode = "true";
        server_cert_name = "argo.priv.os76.xyz";
        ca_cert_path = "/data/store-btrfs/certs/star_priv_os76_xyz_crt_chain.pem";
      };
      smtp = {
        enable = true;
        host = "smtp.home.arpa";
        from_address = "grafana@0.os76.xyz";
      };
      auth = {
        disable_login_form = "False";
        oauth_auto_login = "False";
        disable_signout_menu = "False";
      };
      "auth.anonymous" = {
        enabled = "True";
        org_name = "Os76";
        org_role = "Viewer";
      };
      "auth.generic_oauth" = {
        enabled = "True";
        name = "Keycloak-OAuth";
        allow_sign_up = "True";
        allow_assign_grafana_admin = "False";
        client_id = "$__file{${config.sops.secrets."grafana_auth_client_id".path}}";
        client_secret = "$__file{${config.sops.secrets."grafana_auth_client_secret".path}}";
        scopes = "openid email profile offline_access roles";
        email_attribute_path = "email";
        login_attribute_path = "username";
        name_attribute_path = "full_name";
        auth_url = "https://keycloak.k3s.os76.xyz/realms/os76/protocol/openid-connect/auth";
        token_url = "https://keycloak.k3s.os76.xyz/realms/os76/protocol/openid-connect/token";
        api_url = "https://keycloak.k3s.os76.xyz/realms/os76/protocol/openid-connect/userinfo";
        role_attribute_path = "contains(roles[*], 'grafana_admin') && 'Admin' || contains(roles[*], 'grafana_editor') && 'Editor' || 'Viewer'";
      };
      analytics = {
        reporting_enabled = true;
      };
      alerting = {
        unified_enabled = "True";
        execute_alerts = "True";
      };
    };
  };

  # services.grafana.declarativePlugins = with pkgs.grafanaPlugins; [
  #   grafana-piechart-panel
  # ];
  #
  #
  # Monitoring
  #
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
    };
  };

  #
  # Minio
  #
  services.minio = {
    enable = true;
    region = "zero";
    rootCredentialsFile = minio_root_credentials_file;
    dataDir = [ "/data/store-btrfs/minio/data" ];
    listenAddress = "127.0.0.1:9000";
    consoleAddress = "127.0.0.1:9001";
  };

  #
  # Kakfa / Zookeeper
  #
  # services.zookeeper = {
  #   enable = false;
  #   id = 0;
  #   port = 2181;
  #   dataDir = "/data/zookeeper/data";
  #   servers = ''
  #     server.0=192.168.1.49:2888:3888
  #   '';
  # };
  #
  # services.apache-kafka.enable = false;
  # systemd.services.apache-kafka.after = [ "zookeeper.service" ];
  # services.apache-kafka.settings.listeners =
  #   [ "PLAINTEXT://192.168.1.49:9092" ];
  # services.apache-kafka.settings = {
  #   "broker.id" = 0;
  #   "zookeeper.connect" = [ "192.168.1.49:2181" ];
  #   "auto.create.topics.enable" = true;
  #   "log.dirs" = [ "/data/kakfa/logs" ];
  #   "default.replication.factor" = 1;
  #   "offsets.topic.replication.factor" = 1;
  #   "min.insync.replicas" = 1;
  # };
  #

  #
  # Loki
  #
  # https://gist.github.com/rickhull/895b0cb38fdd537c1078a858cf15d63e

  environment.etc."loki-local-config.yaml".text = ''
    auth_enabled: false

    server:
      http_listen_port: 3100
      grpc_listen_port: 9096

    common:
      instance_addr: 127.0.0.1
      path_prefix: /data/loki/data/tmp
      storage:
        filesystem:
          chunks_directory: /data/loki/data/chunks
          rules_directory: /data/loki/data/rules
      replication_factor: 1
      ring:
        kvstore:
          store: inmemory

    query_range:
      results_cache:
        cache:
          embedded_cache:
            enabled: true
            max_size_mb: 100

    schema_config:
      configs:
        - from: 2020-10-24
          store: tsdb
          object_store: filesystem
          schema: v13
          index:
            prefix: index_
            period: 24h

    ruler:
      alertmanager_url: https://alertmanager.k3s.os76.xyz

    # By default, Loki will send anonymous, but uniquely-identifiable usage and configuration
    # analytics to Grafana Labs. These statistics are sent to https://stats.grafana.org/
    #
    # Statistics help us better understand how Loki is used, and they show us performance
    # levels for most users. This helps us prioritize features and documentation.
    # For more information on what's sent, look at
    # https://github.com/grafana/loki/blob/main/pkg/analytics/stats.go
    # Refer to the buildReport method to see what goes into a report.
    #
    # If you would like to disable reporting, uncomment the following lines:
    #analytics:
    #  reporting_enabled: false
  '';

  services.loki = {
    enable = true;
    dataDir = "/data/loki/data";
    configFile = "/etc/loki-local-config.yaml";
  };

  #
  # Promtail
  #

  services.promtail = {
    enable = false;
    configuration = {
      server = {
        http_listen_port = 3031;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [ { url = "http://127.0.0.1:3100/loki/api/v1/push"; } ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "zero";
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
          ];
        }
      ];
    };
    # extraFlags
  };

  #
  # Tempo
  #
  # Ref: https://github.com/grafana/tempo/blob/main/example/docker-compose/scalable-single-binary/tempo-scalable-single-binary.yaml
  #
  # TODO: add tls: https://grafana.com/docs/tempo/latest/configuration/network/tls/#configure-tls-communication
  #
  sops.templates."tempo-config.yml".content = ''
    usage_report:
      reporting_enabled: false

    server:
      http_listen_port: 3200
      http_listen_address: 0.0.0.0
      grpc_listen_address: 0.0.0.0
      grpc_listen_port: 9095

    distributor:
      receivers:
        jaeger:
          protocols:
            thrift_http:
              endpoint: "0.0.0.0:14268"
            grpc:
              endpoint: "0.0.0.0:14250"
            thrift_binary:
              endpoint: "0.0.0.0:6832"
            thrift_compact:
              endpoint: "0.0.0.0:6831"
        zipkin:
          endpoint: "0.0.0.0:9411"
        otlp:
          protocols:
            grpc:
              endpoint: "0.0.0.0:4317"
            http:
              endpoint: "0.0.0.0:4318"
        opencensus:
          endpoint: "0.0.0.0:55678"

    ingester:
      max_block_duration: 5m

    compactor:
      compaction:
        block_retention: 1h

    metrics_generator:
      registry:
        external_labels:
          source: tempo
      storage:
        path: /var/lib/tempo/generator/wal
        remote_write:
        - url: https://prometheus.k3s.os76.xyz/api/v1/write
          send_exemplars: true
      processor:
        local_blocks:
          filter_server_spans: false

    storage:
      trace:
        backend: s3
        s3:
          endpoint: minio.0.os76.xyz
          bucket: ${config.sops.placeholder.tempo_minio_bucket_name}
          forcepathstyle: true
          insecure: false
          access_key: ${config.sops.placeholder.tempo_minio_access_key}
          secret_key: ${config.sops.placeholder.tempo_minio_secret_key}
        wal:
          path: /var/lib/tempo/wal
        local:
          path: /var/lib/tempo/blocks

    overrides:
      defaults:
        metrics_generator:
          #processors: [service-graphs, span-metrics]
          processors: [local-blocks]
  '';

  sops.templates."tempo-config.yml".owner = "root";
  sops.templates."tempo-config.yml".mode = "0444";

  services.tempo.enable = false;
  services.tempo.configFile = "${config.sops.templates."tempo-config.yml".path}";
  systemd.services.tempo.after = [ "nginx.service" ];
}
