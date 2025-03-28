{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cups
    airscan
    sane-airscan
    sane-backends
    sane-frontends
    xsane
    # skanlite??
  ];

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
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "HP_LaserJet_MFP_M28w_Nix";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.saned.enable = false;
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      hplipWithPlugin
      sane-airscan
    ];
  };
}
