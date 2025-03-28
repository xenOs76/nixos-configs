{pkgs, ...}: let
  ap_gw_ip = "192.168.11.1";
  ap_dhcp_start = "192.168.11.100";
  ap_dhcp_stop = "192.168.11.150";
  ap_dns_ip = "192.168.1.103";
  hostapd_wpa_password_file = "/etc/hostapd/wpaPasswordFile";
in {
  environment.systemPackages = with pkgs; [
    hostapd
    dnsmasq
    bridge-utils
    tcpdump
    iw
    wavemon
  ];

  sops.secrets = {
    "hostapd_wpa_password" = {
      owner = "root";
      path = hostapd_wpa_password_file;
    };
  };

  #
  # AP settings
  #
  networking.interfaces.enp1s0.useDHCP = false;
  networking.networkmanager.unmanaged = [
    "interface-name:wlp3s0"
    "interface-name:enp1s0"
    "interface-name:enp5s0f3u4u3u4"
  ];

  networking.interfaces.wlp3s0 = {
    useDHCP = false;
    ipv4 = {
      addresses = [
        {
          address = ap_gw_ip;
          prefixLength = 24;
        }
      ];
    };
  };

  networking.firewall.enable = true;
  networking.firewall.interfaces."wlp3s0".allowedUDPPorts = [
    53
    67
  ];

  networking.nat = {
    enable = true;
    internalInterfaces = ["wlp3s0"];
    externalInterface = "enp5s0f3u4u3u4";
  };

  environment.etc."dnsmasq-00-access-point-net.conf".text = ''

    cache-size=10000
    domain-needed
    localise-queries
    bogus-priv
    no-resolv

    interface=lo
    interface=wlp3s0
    listen-address=${ap_gw_ip}

    # IPV4
    dhcp-range=wlan,${ap_dhcp_start},${ap_dhcp_stop},48h
    dhcp-option=wlan,3,${ap_gw_ip}
    # 6 dns-server
    dhcp-option=lan,6,${ap_dns_ip}

    no-hosts
  '';

  # requires NAT
  services.dnsmasq = {
    enable = true;
    settings = {
      server = [
        ## Internal GW/DNS
        ap_dns_ip

        # ## Cloudlare
        # "1.1.1.1"
        # "1.0.0.1"
        # # blocks known malware
        # "1.1.1.2"
        # "1.0.0.2"
        # # blocks malware and adult content
        # "1.1.1.3"
        # "1.0.0.3"

        # ## Google
        # "8.8.8.8"
        # "8.8.4.4"

        # ## OpenDNS
        # "208.67.222.222"
        # "208.67.220.220"

        # ## Ad Guard
        # # https://adguard-dns.io/kb/general/dns-providers/
        # # block ads, tracking, and phishing
        # "94.140.14.14"
        # "94.140.15.15"
      ];
      dhcp-leasefile = "/var/lib/dnsmasq/dnsmasq.leases";
      conf-file = "/etc/dnsmasq-00-access-point-net.conf";
    };
  };

  services.hostapd.enable = true;
  #systemd.services.hostapd.wants = [ "br0-netdev.service" ];
  #systemd.services.br0-netdev.before = [ "hostapd.service" ];
  services.hostapd.radios = {
    wlp3s0 = {
      #settings = { bridge = "br0"; };
      band = "5g";
      driver = "nl80211";
      channel = 48;
      countryCode = "DE";
      networks.wlp3s0 = {
        ssid = "AlfaBravoCharlieDelta";
        authentication.wpaPasswordFile = hostapd_wpa_password_file;
        authentication.mode = "wpa2-sha256";
        apIsolate = false;
      };
    };
  };
}
