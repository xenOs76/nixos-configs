{pkgs, ...}: {
  #
  # Docker
  #
  virtualisation.docker = {
    enable = true;
    daemon = {
      settings = {
        data-root = "/data/docker";
      };
    };
    autoPrune = {
      enable = true;
      dates = "daily";
    };
  };
  #virtualisation.docker.extraOptions = "--iptables=false --ip-masq=false --bridge=none";

  #
  # OCI-containers
  #
  systemd.services.docker.after = [
    "br0-netdev.service"
    # "apache-kafka.service"
  ];
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      # kafka-exporter = {
      #   autoStart = false;
      #   image = "danielqsj/kafka-exporter:latest";
      #   ports = [ "9308:9308" ];
      #   cmd = [ "--kafka.server=192.168.1.49:9092" ];
      #   #extraOptions = [ "--network=host" ];
      # };
      # sflow-prometheus = {
      #   autoStart = false;
      #   image = "sflow/prometheus";
      #   ports = [
      #     "8008:8008"
      #     "6343:6343/udp"
      #   ];
      # };

      # https://docs.gomods.io/index.html
      # https://docs.gomods.io/configuration/storage/index.html#disk
      athens-goproxy = {
        autoStart = true;
        image = "gomods/athens";
        ports = [
          "3003:3000"
        ];
        volumes = ["/data/goproxy:/storage"];
        environment = {
          ATHENS_STORAGE_TYPE = "disk";
          ATHENS_DISK_STORAGE_ROOT = "/storage";
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /data/goproxy 0755 1000 1000 - -"
  ];

  #
  # Docker Registry
  #
  services.dockerRegistry = {
    enable = true;
    storagePath = "/data/store-btrfs/docker-registry";
    garbageCollectDates = "daily";
    enableDelete = true;
  };
}
