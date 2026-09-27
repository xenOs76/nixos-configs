{
  config,
  lib,
  pkgs,
  stdenv,
  ...
}: let
  gw_home_arpa = "192.168.1.103";
  ns_home_arpa = "192.168.1.103";
  zero_home_arpa = "192.168.1.49";
in {
  imports = [
    ./hardware-configuration.nix
    # https://nixos.wiki/wiki/Scanners#Network_scanning
    #./sane-extra-config.nix
  ];

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system = {
    stateVersion = "26.05";
    copySystemConfiguration = false;
  };

  sops.secrets.description = {};

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  services = {
    openssh.enable = true;
    fwupd.enable = true;
    pcscd.enable = true;
    resolved.enable = false;
  };

  networking = {
    hostName = "zero";
    domain = "home.arpa";
    networkmanager.enable = false;
    firewall.enable = true;
    wireless.enable = lib.mkForce false;
    dhcpcd.enable = false;
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = zero_home_arpa;
        prefixLength = 24;
      }
    ];
    defaultGateway = gw_home_arpa;
    nameservers = [ns_home_arpa];
    useHostResolvConf = true;
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
    bat
    bat
    bat-extras.batman
    curl
    dig
    dust
    eza
    fd
    file
    fzf
    git
    glow
    htop
    jq
    lazygit
    lf
    lsof
    netcat
    nixfmt
    nixpkgs-fmt
    openssl_3
    ripgrep
    screen
    sops
    tree
    unzip
    vim
    wget
    zoxide
  ];

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
