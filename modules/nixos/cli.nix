{pkgs, ...}: {
  nix.settings.trusted-users = [
    "root"
    "xeno"
  ];
  environment.systemPackages = with pkgs; [
    vim
    git
    alejandra
    cachix
    sops
    age
    ssh-to-age
    inotify-tools
    dig
  ];
}
