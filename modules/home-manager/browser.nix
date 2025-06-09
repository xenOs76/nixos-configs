{
  programs.firefox.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [
      "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "olhelnoplefjdmncknfphenjclimckaf" # catppuccin-frappe theme
    ];
  };
}
