{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    catppuccin-sddm
    kdePackages.sddm-kcm
    # kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kcolorchooser
    kdePackages.kolourpaint
    kdiff3
    kdePackages.partitionmanager
    haruna
    wayland-utils
    wl-clipboard

    xdg-desktop-portal
    kdePackages.xdg-desktop-portal-kde

    cosmic-reader
    cosmic-ext-applet-minimon
    cosmic-ext-calculator
    cosmic-ext-applet-privacy-indicator
    cosmic-ext-tweaks
  ];

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-store
    cosmic-term
    cosmic-wallpapers
  ];

  services = {
    xserver.enable = true;

    # COSMIC
    system76-scheduler.enable = true;
    desktopManager = {
      cosmic.enable = true;
    };
    displayManager = {
      cosmic-greeter.enable = true;
      autoLogin = {
        enable = true;
        user = "xeno";
      };
    };

    # KDE6
    desktopManager = {
      plasma6.enable = false;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = false;
        wayland.enable = true;
        settings = {
          Autologin = {
            Session = "plasma.desktop";
            User = "xeno";
          };
        };
      };
    };
  };

  programs.dconf.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    xdg-desktop-portal-cosmic
  ];

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
