{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [
      "/home"
      "/data"
    ];
  };
}
