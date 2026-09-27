{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/nix-gc.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # networking.hostName = "xor-nixos";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking = {
    hostName = "xor";
    domain = "home.arpa";
    dhcpcd.enable = false;
    interfaces.enu1u1u1.ipv4.addresses = [
      {
        address = "192.168.1.78";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.103";
    nameservers = ["192.168.1.103"];
  };

  security.sudo.wheelNeedsPassword = false;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xeno = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [zellij];
  };

  users.users.xeno.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLzu2nNp/Ff/4UMHp5bdSlGhEsb21H24i4JmkNCPhd7PqgRQy+tdSIl5nMTVn1DylWdw8IbYyyeCu1nk8pWtEv8xsAEE0qhwsCrjT1wFHuZppfiw2YAescWESbmyKM/Z3/Zvz1glrC2DJqxI/1Xn+sujYYkIlpUaY9xvQauZB4BHufPTgguS6Wn3vja1IRg0WKZubutdrwhHh8iwSlDQWYsLqTPPkiUejmayQGcTSSQ6tLoXNpyJjKwk7ol8NmAccFCx8tJ/hE5Xlyfuko6FvZSLTPmO5+Ppg4Jo2p1jsj4d2IBBxfAGedZZxb2Fjakf/Mkv6AsR+Laqg0yd6k8RI3lZq+KaQPd57SZaV4uRUlB9bRw1E/x3DwilZ0/360qDrYxH+gS20rC7VaazEFdJWL2YviqFuyJw86TUijfmGM4h5kvmNJMcB/3AtDZJHiWbyWVX+1t7V9yigfnXBYJa+sk6tWGkbUPTxo/Dcrx0fRKNXZ4bIYid3nWZ7Hj2NKATk= xeno@zero"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGAuzFXAPyOFrAhj4eUGk5CYrULjwD7I/CQvVQ1J65v xeno@nemo"
  ];

  environment.systemPackages = with pkgs; [
    home-assistant-custom-components.ha_mcp_tools
    home-assistant-custom-components.prometheus_sensor
    htop
    lsof
    sqlite
    tcpdump
    vim
    wget
    zellij
  ];

  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
    "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
    "f ${config.services.home-assistant.configDir}/scripts.yaml 0755 hass hass"
    "L+ ${config.services.home-assistant.configDir}/control-panel.yaml - - - - ${./lovelace/control-panel.yaml}"
    "d ${config.services.home-assistant.configDir}/backups 770 hass hass 14d"
    "Z ${config.services.home-assistant.configDir}/custom_components 770 hass hass - -"
    "C ${config.services.home-assistant.configDir}/custom_components/dwd - - - - ${pkgs.home-assistant-custom-components.dwd}/custom_components/dwd"
  ];

  services = {
    openssh.enable = true;

    prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "logind"
        "systemd"
      ];
      disabledCollectors = ["textfile"];
    };

    home-assistant = {
      enable = true;
      extraComponents = [
        # Components required to complete the onboarding
        "application_credentials"
        "automation"
        "backup"
        "bthome"
        "counter"
        "esphome"
        "frontend"
        "hardware"
        "input_boolean"
        "input_button"
        "input_datetime"
        "input_number"
        "input_select"
        "input_text"
        "logger"
        "mcp"
        "mcp_server"
        "mqtt"
        "network"
        "openweathermap"
        "person"
        "ping"
        "prometheus"
        "scene"
        "schedule"
        "script"
        "shelly"
        "slack"
        "system_health"
        "tag"
        "tasmota"
        "timer"
        "tplink"
        "wiz"
        "wled"
        "zone"
      ];
      config = {
        #
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        #
        # NixOS specific examples:
        # https://github.com/Mic92/dotfiles/blob/main/machines/eve/modules/home-assistant/default.nix
        #
        default_config = {};
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [
            "127.0.0.1"
            "::1"
            "192.168.1.0/24"
          ];
        };
        lovelace = {
          dashboards = {
            "control-panel" = {
              mode = "yaml";
              title = "Control Panel";
              icon = "mdi:alarm-panel-outline";
              show_in_sidebar = true;
              require_admin = false;
              filename = "control-panel.yaml";
            };
          };
        };

        mqtt = {
          sensor = [
            {
              name = "RoomTemp";
              default_entity_id = "sensor.mkr1010_scd41_temp";
              device_class = "temperature";
              state_topic = "mkr1010/env";
              # suggested_display_precision = 2;
              unit_of_measurement = "°C";
              value_template = "{{ value_json.scd41_temp| round(2) }}";
            }
            {
              name = "RoomHum";
              default_entity_id = "sensor.mkr1010_scd41_hum";
              device_class = "humidity";
              state_topic = "mkr1010/env";
              # suggested_display_precision = 2;
              unit_of_measurement = "%";
              value_template = "{{ value_json.scd41_hum| round(2) }}";
            }
            {
              name = "RoomCO2";
              default_entity_id = "sensor.mkr1010_scd41_co2";
              device_class = "carbon_dioxide";
              state_topic = "mkr1010/env";
              unit_of_measurement = "ppm";
              value_template = "{{ value_json.scd41_co2 }}";
            }
          ];
        };
        automation = [
          {
            id = "1731791496";
            alias = "DailyBackupNix";
            description = "";
            trigger = [
              {
                platform = "time";
                at = "06:00:00";
              }
            ];
            condition = [];
            action = [
              {
                service = "backup.create";
                metadata = {};
                data = {};
              }
            ];
            mode = "single";
          }
        ];
        "automation ui" = "!include automations.yaml";
        "scene manual" = [];
        "scene ui" = "!include scenes.yaml";
        script = [
          {
            testnotification = {
              alias = "TestNotificationFromNixConf";
              sequence = [
                {
                  service = "notify.mobile_app_xiaomipoco";
                  metadata = {};
                  data = {
                    message = "Test notification script";
                    title = "Test notification";
                  };
                }
                {
                  service = "notify.os76";
                  metadata = {};
                  data = {
                    message = "Test notification script";
                  };
                }
              ];
              mode = "single";
              icon = "mdi:slack";
            };
          }
        ];
        # FIXME: not included correctly
        "scripts ui" = "!include scripts.yaml";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  #system.copySystemConfiguration = true;

  # evaluating and copying closures from zero to xor
  # signature check need to be disabled for nix
  nix.settings.require-sigs = false;
  system.stateVersion = "26.05";
}
