{
  imports = [
    ./nix-gc.nix
    ./nix-github-token.nix
    ./nix-binary-cache.nix
    ./cli.nix
    ./fonts.nix
    ./print-scan.nix
    ./sound.nix
    ./bluetooth.nix
    ./virtualization.nix
    # ./nixvim
    ./desktop-manager.nix
    ../common/catppuccin-whiskers.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "frappe";
    accent = "mauve";
    grub.enable = true;
    tty.enable = true;
    sddm.enable = true;
    plymouth.enable = true;
  };
}
