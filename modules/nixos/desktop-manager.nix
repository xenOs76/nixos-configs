{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
    catppuccin-sddm
  ];

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "catppuccin-mocha";
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

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
