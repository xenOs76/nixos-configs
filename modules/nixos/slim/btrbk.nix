{
  #
  #  Btrbk backup
  #
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
}
