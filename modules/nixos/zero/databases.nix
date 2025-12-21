{pkgs, ...}: {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/data/mysql";
    ensureUsers = [
      {
        name = "grafana";
        ensurePermissions = {
          "grafana.*" = "ALL PRIVILEGES";
        };
      }
      {
        name = "backup";
        ensurePermissions = {
          "*.*" = "SELECT, LOCK TABLES";
        };
      }
    ];
    ensureDatabases = ["grafana"];
  };

  services.mysqlBackup = {
    enable = true;
    user = "backup";
    location = "/data/store-btrfs/mysql-backup/";
    databases = ["grafana"];
    compressionAlg = "gzip";
    calendar = "6 *-*-* 8:00:00";
  };
}
