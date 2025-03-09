{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Containers
    docker-buildx
    lazydocker
    regclient
    reg
  ];
}
