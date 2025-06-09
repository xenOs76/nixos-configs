{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    git
    alejandra
    sops
    age
    ssh-to-age
    inotify-tools
  ];
}
