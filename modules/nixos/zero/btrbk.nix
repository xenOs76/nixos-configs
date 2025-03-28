{pkgs, ...}: let
  local_to_argo_ssh_key_path = "/etc/btrbk/id_ed25519_local_to_argo";
in {
  environment.systemPackages = with pkgs; [
    btrbk
    rsync
  ];

  sops.secrets = {
    "id_ed25519_local_to_argo" = {
      owner = "root";
      path = local_to_argo_ssh_key_path;
    };
  };

  services.btrbk.instances.local_backup.onCalendar = "daily";
  services.btrbk.instances.local_backup.settings = let
    snapshot_settings = {
      snapshot_create = "always";
      snapshot_dir = "snaps";
    };
  in {
    snapshot_preserve = "6d 0w 0m";
    snapshot_preserve_min = "2d";
    volume = {
      "/home/" = {
        subvolume = {
          xeno = snapshot_settings;
          backup = snapshot_settings;
        };
      };
    };
    volume = {
      "/data/store-btrfs/" = {
        subvolume = {
          certs = snapshot_settings;
          docker-registry = snapshot_settings;
          nginx = snapshot_settings;
          aptly = snapshot_settings;
          minio = snapshot_settings;
        };
      };
    };
  };

  services.btrbk.instances.local_to_argo.onCalendar = "*-*-* 08:30:00";
  services.btrbk.instances.local_to_argo.settings = let
    send_to_argo_target = {
      snapshot_create = "no";
      snapshot_dir = "snaps";
      target = {
        "ssh://argo.priv.os76.xyz/memento/back/zero-nix_snaps/" = {
          ssh_identity = local_to_argo_ssh_key_path;
          ssh_user = "root";
        };
      };
    };
  in {
    target_preserve_min = "7d";
    target_preserve = "7d 4w";
    volume = {
      "/home/" = {
        subvolume = {
          xeno = send_to_argo_target;
          backup = send_to_argo_target;
        };
      };
    };
    volume = {
      "/data/store-btrfs" = {
        subvolume = {
          certs = send_to_argo_target;
          docker-registry = send_to_argo_target;
          aptly = send_to_argo_target;
          nginx = send_to_argo_target;
          minio = send_to_argo_target;
        };
      };
    };
  };

  services.btrbk.instances.local_nvme_to_sda.onCalendar = "*-*-* 10:30:00";
  services.btrbk.instances.local_nvme_to_sda.settings = let
    snapshot_move_settings = {
      snapshot_create = "no";
      snapshot_dir = "snaps";
      target = "/data/store-btrfs/snaps/from_nvme_to_sda/";
    };
  in {
    target_preserve_min = "7d";
    target_preserve = "7d 4w";
    volume = {
      "/home/" = {
        subvolume = {
          xeno = snapshot_move_settings;
          backup = snapshot_move_settings;
        };
      };
    };
  };

  systemd.timers."rsync-to-backup-subvol" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "30m";
      OnUnitActiveSec = "5m";
      OnCalendar = "*-*-* 6,9,12,15,18,20:30:00";
      Persistent = true;
      Unit = "rsync-to-backup-subvol.service";
    };
  };

  systemd.services."rsync-to-backup-subvol" = {
    script = ''
      set -eu
      touch /etc/backup-marker-rsync-copy-links
      ${pkgs.rsync}/bin/rsync -azp -L --delete --numeric-ids --acls --xattrs \
      --exclude=*autovt@tty1.service  --exclude nixos/result   /etc/nixos /home/backup/
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
