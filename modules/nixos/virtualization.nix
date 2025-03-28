{pkgs, ...}: {
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv6l-linux"
    "armv7l-linux"
  ];

  environment.systemPackages = with pkgs; [
    qemu_full

    docker-buildx
    lazydocker
    regclient
    reg
  ];
}
