# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "ehci_pci" "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  boot.extraModulePackages = [ ];

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
    amdvlk.enable = true;
    amdvlk.package = pkgs.amdvlk;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c89cb9a1-23a8-4c09-8259-b53bfaeb7f00";
    fsType = "xfs";
  };

  #  fileSystems."/usr" =
  #    { device = "/dev/disk/by-uuid/5a615c83-e18b-4591-9d7c-e2cb297579c5";
  #      fsType = "xfs";
  #    };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/1abc7d58-6d74-4e32-9c38-9041164dc525";
    fsType = "btrfs";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/618C-CA5C";
    fsType = "vfat";
  };

  fileSystems."/data" = {
    device = "/dev/vgdata/lvdata";
    fsType = "ext4";
    options = [ "defaults" "nofail" "nodev" ];
  };

  systemd.tmpfiles.rules = [
    "d /data/downloads 0770 xeno users -"
    "d /data/loki 0770 loki loki -"
    "d /data/loki/data 0770 loki loki -"
  ];

  fileSystems."/data/store-btrfs" = {
    device = "/dev/vgdata/lvstore-btrfs";
    fsType = "btrfs";
    options = [ "defaults" "nofail" "nodev" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0f3u4u3u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "apm=power_off" "acpi=force" "reboot=acpi" ];

  hardware.graphics = {
    enable = true;
    # driSupport32Bit = true;
    extraPackages = with pkgs; [ amdvlk ];
  };
}
