{pkgs, ...}: {
  nix.settings.trusted-users = [
    "root"
    "xeno"
  ];
  environment.systemPackages = with pkgs; [
    vim
    git
    alejandra
    sops
    age
    ssh-to-age
    inotify-tools
    dig
  ];
}
