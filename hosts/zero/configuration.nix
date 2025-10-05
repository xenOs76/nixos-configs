{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # https://nixos.wiki/wiki/Scanners#Network_scanning
    #./sane-extra-config.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  sops.secrets.description = {};

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  networking = {
    hostName = "zero";
    domain = "home.arpa";
    wireless.enable = false;
    networkmanager.enable = true;
    dhcpcd.enable = false;
    interfaces.enp2s0f0.ipv4.addresses = [
      {
        address = "192.168.1.49";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.103";
    nameservers = ["192.168.1.103"];
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MONETARY = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  #console = {
  #font = "Lat2-Terminus16";
  #keyMap = "us";
  #useXkbConfig = true; # use xkb.options in tty.
  #lo
  #};

  security.sudo.wheelNeedsPassword = false;

  users.users.xeno = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout"
      "docker"
    ];
    packages = with pkgs; [git];
  };

  environment.systemPackages = with pkgs; [
    nixfmt-classic
    nixpkgs-fmt
    alejandra
    git
    vim
    sops
    lazygit
    lf
    zoxide
    fzf
    bat
    bat-extras.batman
    glow
    eza
    jq
    unzip
    tree
    file
    lsof
    netcat
    du-dust
    dig
    wget
    ripgrep
    fd
    curl
    htop
    bat
    screen
    openssl_3
  ];

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  #  programs.bash.blesh.enable = true;

  networking.firewall.enable = true;
  services.openssh.enable = true;
  services.fwupd.enable = true;
  services.pcscd.enable = true;

  system.copySystemConfiguration = false;
  system.stateVersion = "25.05";
}
