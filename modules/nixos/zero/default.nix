{pkgs, ...}: {
  imports = [
    ./network.nix
    ./btrfs.nix
    ./btrbk.nix
    ./virtualization.nix
    ./monitoring.nix
    ./nginx.nix
    ./databases.nix
  ];

  services.journald.extraConfig = "SystemMaxUse=500m";
  boot.kernelParams = ["amdgpu.sg_display=0" "amdgpu.dcdebugmask=0x10" "amdgpu.dc=1"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.firmware = [pkgs.linux-firmware];
  hardware.enableAllFirmware = true;
}
