{pkgs, ...}: {
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox-bin;
  # };

  programs.chromium = {
    enable = true;
    extensions = [
      "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "olhelnoplefjdmncknfphenjclimckaf" # catppuccin-frappe theme
    ];
  };
}
