{config, ...}: {
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

  sops.secrets = {
    goproxy_github_token = { };
    goproxy_gitea_token = { };
  };

  sops.templates."goproxy-gitconfig".content = ''
    [url "https://${config.sops.placeholder.goproxy_github_token}@github.com/"]
        insteadOf = https://github.com/
    [url "https://xeno:${config.sops.placeholder.goproxy_gitea_token}@git.priv.os76.xyz/"]
        insteadOf = https://git.priv.os76.xyz/
  '';
  sops.templates."goproxy-gitconfig".owner = "root";
  sops.templates."goproxy-gitconfig".mode = "0400";

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

      # https://git.priv.os76.xyz/xeno/docker-images (goproxy/)
      goproxy = {
        autoStart = true;
        image = "registry.0.os76.xyz/xeno/goproxy:latest";
        ports = [
          "3003:8081"
        ];
        volumes = [
          "/data/goproxy:/cache"
          "${config.sops.templates.goproxy-gitconfig.path}:/root/.gitconfig:ro"
        ];
        cmd = [
          "-listen=0.0.0.0:8081"
          "-cacheDir=/cache"
          "-exclude=github.com/xenos76/*,git.priv.os76.xyz/*"
          "-cacheExpire=720h"
        ];
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /data/goproxy 0755 root root - -"
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
