{ pkgs, ... }: {
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
    age
    ausweisapp
    cachix
    dig
    git
    inetutils
    inotify-tools
    nix-tree
    nixfmt
    pcsclite
    sops
    ssh-to-age
    vim
  ];
}
