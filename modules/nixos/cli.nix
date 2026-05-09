{pkgs, ...}: {
  nix.settings.trusted-users = [
    "root"
    "xeno"
  ];

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    nix-ld.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    alejandra
    cachix
    nix-tree
    sops
    age
    ssh-to-age
    inotify-tools
    dig
  ];
}
