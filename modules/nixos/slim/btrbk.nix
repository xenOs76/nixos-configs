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
  services.btrbk.instances.local_backup.settings = {
    snapshot_preserve = "6d 1w 0m";
    snapshot_preserve_min = "3d";
    volume = {
      "/home/" = {
        subvolume = {
          xeno = {
            snapshot_create = "always";
            snapshot_dir = "snaps";
          };
        };
      };
    };
  };

  services.btrbk.instances.local_nvme_to_sda.onCalendar = "*-*-* 10:30:00";
  services.btrbk.instances.local_nvme_to_sda.settings = {
    target_preserve_min = "7d";
    target_preserve = "7d 4w";
    volume = {
      "/home/" = {
        subvolume = {
          xeno = {
            snapshot_create = "no";
            snapshot_dir = "snaps";
            target = "/data/backup/from_nvme_to_sda/";
          };
        };
      };
    };
  };

  services.btrbk.instances.local_to_argo.onCalendar = "*-*-* 10:30:00";
  services.btrbk.instances.local_to_argo.settings = let
    send_to_argo_target = {
      snapshot_create = "no";
      snapshot_dir = "snaps";
      target = {
        "ssh://argo.priv.os76.xyz/memento/back/slim-nix_snaps/" = {
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
        };
      };
    };
  };
}
