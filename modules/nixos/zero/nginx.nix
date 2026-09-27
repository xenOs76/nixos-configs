{
  config,
  pkgs,
  ...
}: let
  certs_base_dir = "/data/store-btrfs/certs";
  ssl_certificate_bundle_path = "${certs_base_dir}/star_0_os76_xyz_full.pem";
  ssl_certificate_key_path = "${certs_base_dir}/star_0_os76_xyz_priv_key.pem";
  garage_web_ssl_cert = "${certs_base_dir}/star_garage_web_0_os76_xyz_full.pem";
  garage_web_ssl_key = "${certs_base_dir}/star_garage_web_0_os76_xyz_priv_key.pem";
  garage_s3_ssl_cert = "${certs_base_dir}/star_garage_s3_0_os76_xyz_full.pem";
  garage_s3_ssl_key = "${certs_base_dir}/star_garage_s3_0_os76_xyz_priv_key.pem";
  # Static art for Grafana Canvas Homelab Map (os76-tf dashboard).
  os76MapAssets = pkgs.runCommand "os76-map-assets" {} ''
    mkdir -p $out
    cp ${./assets/os76-homelab-map-bg.png} $out/os76-homelab-map-bg.png
  '';
in {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    enableReload = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    appendHttpConfig = ''

      log_format kv 'site="$server_name" server="$host" dest_port="$server_port" dest_ip="$server_addr" '
                    'src="$remote_addr" src_ip="$realip_remote_addr" user="$remote_user" '
                    'time_local="$time_local" protocol="$server_protocol" status="$status" '
                    'bytes_out="$bytes_sent" bytes_in="$upstream_bytes_received" '
                    'http_referer="$http_referer" http_user_agent="$http_user_agent" '
                    'nginx_version="$nginx_version" http_x_forwarded_for="$http_x_forwarded_for" '
                    'http_x_header="$http_x_header" uri_query="$query_string" uri_path="$uri" '
                    'http_method="$request_method" response_time="$upstream_response_time" '
                    'cookie="$http_cookie" request_time="$request_time" category="$sent_http_content_type" https="$https"';

      access_log /var/log/nginx/access.log kv;
      error_log /var/log/nginx/error.log;

    '';
  };
  services.nginx.virtualHosts = {
    "zero.0.os76.xyz" = {
      default = true;
      root = "/data/store-btrfs/nginx/default";
      serverAliases = ["zero.home.arpa"];
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      extraConfig = ''
        # HSTS (ngx_http_headers_module is required) (63072000 seconds)
        #add_header Strict-Transport-Security "max-age=63072000" always;
      '';
      locations."/" = {};
      locations."/status" = {
        extraConfig = ''
          stub_status;
        '';
      };
    };

    "loki.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3100";
      };
    };

    "grafana.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      # Served before the Grafana proxy so Canvas can load a durable HTTPS backdrop.
      locations."/os76-map-assets/" = {
        alias = "${os76MapAssets}/";
        extraConfig = ''
          add_header Cache-Control "public, max-age=86400";
        '';
      };
      locations."/" = {
        proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };

    "registry.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.dockerRegistry.port}";
      };

      extraConfig = ''
        client_max_body_size 2048M;
      '';
    };

    "goproxy.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3003";
        recommendedProxySettings = true;
      };

      extraConfig = ''
        client_max_body_size 2048M;
      '';
    };

    "garage-admin.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3903";
        recommendedProxySettings = true;
      };

      extraConfig = ''
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        # Disable buffering to a temporary file.
        proxy_max_temp_file_size 0;
      '';
    };

    "garage-s3.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3900";
        recommendedProxySettings = true;
      };

      extraConfig = ''
        # Allow any size object upload (nginx default is 1m).
        # Required for restic/autorestic path-style S3 to this host.
        client_max_body_size 0;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        # Disable buffering to a temporary file.
        proxy_max_temp_file_size 0;
      '';
    };

    "*.garage-s3.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = garage_s3_ssl_cert;
      sslCertificateKey = garage_s3_ssl_key;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3900";
        recommendedProxySettings = true;
      };

      extraConfig = ''
        # Allow any size object upload (nginx default is 1m).
        client_max_body_size 0;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        # Disable buffering to a temporary file.
        proxy_max_temp_file_size 0;
      '';
    };

    "*.garage-web.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = garage_web_ssl_cert;
      sslCertificateKey = garage_web_ssl_key;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3902";
        recommendedProxySettings = true;
      };

      extraConfig = ''
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        # Disable buffering to a temporary file.
        proxy_max_temp_file_size 0;
      '';
    };

    # "apt.0.os76.xyz" = {
    #   forceSSL = true;
    #   sslCertificate = ssl_certificate_bundle_path;
    #   sslCertificateKey = ssl_certificate_key_path;
    #   root = "/data/store-btrfs/aptly/apt-repo/root/public";
    #   locations."/" = {
    #     extraConfig = ''
    #       autoindex on;
    #     '';
    #     recommendedProxySettings = true;
    #   };
    # };
  };
}
