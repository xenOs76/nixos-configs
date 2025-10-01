{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    catppuccin-sddm
    kdePackages.sddm-kcm
    kdePackages.discover
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kcolorchooser
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdiff3
    kdePackages.partitionmanager
    haruna
    wayland-utils
    wl-clipboard
  ];

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = true;
      settings = {
        Autologin = {
          Session = "plasma.desktop";
          User = "xeno";
        };
      };
    };
  };

  programs.dconf.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  ## Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  ## kodi
  # services.xserver.desktopManager.kodi.enable = true;
  # services.xserver.desktopManager.kodi.package =
  #   pkgs.kodi-wayland.passthru.withPackages (kodiPkgs:
  #     with kodiPkgs; [
  #       youtube # or invidious?
  #       netflix
  #       libretro
  #       inputstream-ffmpegdirect
  #       inputstream-adaptive
  #       somafm
  #       radioparadise
  #     ]);
  #
  # networking.firewall.allowedTCPPorts = [
  #   8080 # Kodi
  # ];
  #
  # networking.firewall.allowedUDPPorts = [
  #   8080 # Kodi
  # ];
}
