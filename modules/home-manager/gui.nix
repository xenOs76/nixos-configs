{pkgs, ...}: {
  home.packages = with pkgs; [
    # Messaging
    slack
    element-desktop
    thunderbird-bin

    # QT
    qtpass
    pinentry-qt
    yubikey-manager-qt
    yubikey-personalization-gui

    # kde6
    kdePackages.ark
    kdePackages.kcalc
    kdePackages.kgamma
    kdePackages.kate
    kdePackages.kcharselect
    kdePackages.kgpg
    # kdePackages.kdeconnect-kde
    kdePackages.skanlite
    kdePackages.dragon
    kdePackages.spectacle
    kdePackages.okular
    #    kdePackages.neochat
    kdePackages.tokodon
    # kdePackages.ktouch
    kdePackages.ktorrent
    kdePackages.gwenview
    kdePackages.filelight
    kdePackages.plasma-browser-integration
    kdePackages.kasts
    # kdePackages.plasmatube
  ];

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
}
