{pkgs, ...}: {
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv6l-linux"
    "armv7l-linux"
  ];

  environment.systemPackages = with pkgs; [
    qemu_full

    docker
    docker-ls
    docker-buildx
    lazydocker
    regclient
    reg
  ];

  virtualisation.docker.enable = true;
  users.users.xeno.extraGroups = ["docker"];
}
