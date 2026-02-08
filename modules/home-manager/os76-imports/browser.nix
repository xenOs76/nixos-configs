{pkgs, ...}: {
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox-bin;
  # };

  # TODO enable HTTPS everywere
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "olhelnoplefjdmncknfphenjclimckaf" # catppuccin-frappe theme
    ];
  };
}
