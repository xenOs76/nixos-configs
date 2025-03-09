{pkgs, ...}: {
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [pkgs.hplipWithPlugin];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_LaserJet_MFP_M28w_Nix";
        location = "Home - AlfaBravoCharlie network, NixOS provisioned";
        deviceUri = "socket://printer.home.arpa:9100";
        model = "drv:///hp/hpcups.drv/hp-laserjet_mfp_m28-m31.ppd";
        ppdOptions = {PageSize = "A4";};
      }
    ];
    ensureDefaultPrinter = "HP_LaserJet_MFP_M28w_Nix";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # enable scanner
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin pkgs.sane-airscan];
  };
  services.saned.enable = false;
}
