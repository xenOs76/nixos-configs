{pkgs, ...}: {
  home.packages = with pkgs; [
    # Messaging
    slack
    element-desktop
    thunderbird-bin

    # QT
    qtpass
    pinentry-qt
    yubioath-flutter

    # kde6
    kdePackages.ark
    # kdePackages.kcalc
    # kdePackages.kgamma
    # kdePackages.kate
    kdePackages.kcharselect
    kdePackages.kgpg
    # kdePackages.kdeconnect-kde
    kdePackages.skanlite
    kdePackages.spectacle
    kdePackages.okular
    # kdePackages.neochat
    # kdePackages.tokodon
    # kdePackages.ktouch
    kdePackages.gwenview
    kdePackages.filelight
    kdePackages.plasma-browser-integration
    kdePackages.kasts
    kdePackages.plasmatube
  ];

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
