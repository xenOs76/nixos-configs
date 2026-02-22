{pkgs, ...}: {
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox-bin;
  # };

  # TODO enable HTTPS everywere
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--no-default-browser-check"
    ];
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "olhelnoplefjdmncknfphenjclimckaf" # catppuccin-frappe theme
    ];
  };
}
