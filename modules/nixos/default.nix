{
  imports = [
    ./cli.nix
    ./fonts.nix

    # TODO enable when hplip bug fix merged
    #./print-scan.nix

    ./sound.nix
    ./bluetooth.nix
    ./virtualization.nix
    ./nixvim-full
    ./desktop-manager.nix
  ];
}
