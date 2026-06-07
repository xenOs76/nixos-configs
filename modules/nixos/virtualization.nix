{pkgs, ...}: {
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv6l-linux"
    "armv7l-linux"
  ];

  environment.systemPackages = with pkgs; [
    qemu_full

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
  users.users.xeno.extraGroups = ["docker"];
}
