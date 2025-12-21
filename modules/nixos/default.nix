{
  imports = [
    ./cli.nix
    ./fonts.nix
    ./print-scan.nix
    ./sound.nix
    ./bluetooth.nix
    ./virtualization.nix
    ./nixvim
    ./desktop-manager.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python3.12-ecdsa-0.19.1"
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
