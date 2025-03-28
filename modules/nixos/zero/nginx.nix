{config, ...}: let
  ssl_certificate_bundle_path = "/data/store-btrfs/certs/star_0_os76_xyz_full.pem";
  ssl_certificate_key_path = "/data/store-btrfs/certs/star_0_os76_xyz_priv_key.pem";
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

    "minio-console.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      extraConfig = ''
        # HSTS (ngx_http_headers_module is required) (63072000 seconds)
        add_header Strict-Transport-Security "max-age=63072000" always;
      '';
      locations."/" = {
        proxyPass = "http://localhost:9001";
        extraConfig = ''

          #
          # https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html
          #

          #proxy_set_header Host $http_host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-NginX-Proxy true;

          # This is necessary to pass the correct IP to be hashed
          real_ip_header X-Real-IP;

          # To support websockets in MinIO versions released after January 2023
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";

          # Some environments may encounter CORS errors (Kubernetes + Nginx Ingress)
          # Uncomment the following line to set the Origin request to an empty string
          # proxy_set_header Origin \'\';

          chunked_transfer_encoding off;

        '';
      };
    };

    "minio.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      extraConfig = ''

        # HSTS (ngx_http_headers_module is required) (63072000 seconds)
        add_header Strict-Transport-Security "max-age=63072000" always;

        # Allow special characters in headers
        ignore_invalid_headers off;

        # Allow any size file to be uploaded.
        # Set to a value such as 1000m; to restrict file size to a specific value
        client_max_body_size 0;

        # Disable buffering
        proxy_buffering off;
        proxy_request_buffering off;

      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:9000";
        extraConfig = ''

          #
          # https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html
          #
          proxy_connect_timeout 300;

          # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
          proxy_http_version 1.1;
          proxy_set_header Connection "";
          chunked_transfer_encoding off;

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
        proxyPass = "http://127.0.0.1:5000";
      };

      extraConfig = ''
        client_max_body_size 2048M;
      '';
    };

    "apt.0.os76.xyz" = {
      forceSSL = true;
      sslCertificate = ssl_certificate_bundle_path;
      sslCertificateKey = ssl_certificate_key_path;
      root = "/data/store-btrfs/aptly/apt-repo/root/public";
      locations."/" = {
        extraConfig = ''
          autoindex on;
        '';
        recommendedProxySettings = true;
      };
    };
  };
}
