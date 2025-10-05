{
  imports = [
    ./cli.nix
    ./fonts.nix
    ./print-scan.nix
    ./sound.nix
    ./bluetooth.nix
    ./virtualization.nix
    ./nixvim-full
    ./desktop-manager.nix
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
