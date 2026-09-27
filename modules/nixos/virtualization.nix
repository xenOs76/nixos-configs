{pkgs, ...}: {
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv6l-linux"
    "armv7l-linux"
  ];

  environment.systemPackages = with pkgs; [
    qemu_full
    virt-manager

    docker_29
    docker-ls
    docker-buildx
    docker-compose
    lazydocker
    regclient
    reg
  ];

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
  };

  # Default NAT (virbr0) for qemu bridge guests (e.g. os76-public franti-vm).
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = ["virbr0"];
  };

  # Autostart the shipped "default" network so virbr0 exists after boot.
  systemd.tmpfiles.rules = [
    "L+ /var/lib/libvirt/qemu/networks/autostart/default.xml - - - - /var/lib/libvirt/qemu/networks/default.xml"
  ];

  users.users.xeno.extraGroups = [
    "docker"
    "libvirtd"
  ];
}
