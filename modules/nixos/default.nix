{
  imports = [
    ./cli.nix
    ./fonts.nix
    ./print-scan.nix
    ./sound.nix
    ./bluetooth.nix
    ./virtualization.nix
    # ./nixvim
    ./desktop-manager.nix
  ];

  # nixpkgs.config.permittedInsecurePackages = [
  #   "python3.12-ecdsa-0.19.1"
  # ];

  nix = {
    settings = {
      auto-optimise-store = true;
      keep-outputs = false;
      keep-derivations = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

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
