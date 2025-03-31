{
  config,
  lib,
  pkgs,
  ...
}: let
  slim_sda1_luks_key_path = "/etc/slim_sda1_luks.key";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.auto-optimise-store = true;

  sops.secrets.description = {};
  sops.secrets.xeno_pw_hash.neededForUsers = true;
  sops.secrets.slim_sda1_luks_key = {
    owner = "root";
    path = slim_sda1_luks_key_path;
  };

  security.sudo.wheelNeedsPassword = false;

  boot = {
    initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/497734d2-3981-41bc-805d-5839cef1e85c";
    loader = {
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        device = "/dev/nvme0n1";
        efiSupport = true;
        efiInstallAsRemovable = false;
      };
    };
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "armv6l-linux"
      "armv7l-linux"
    ];
  };

  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      # <volume-name> <encrypted-device> [key-file] [options]
      cryptDataPv UUID=bfadeb78-06fa-4ee3-9243-1abcb6f3ca84 ${slim_sda1_luks_key_path}
    '';
  };

  networking.hostName = "slim";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.xeno = {
    isNormalUser = true;
    #
    # use hashedPasswordFile with a secret when creating
    # new users. It will not impact existing ones
    #
    #hashedPasswordFile = config.sops.secrets.xeno_pw_hash.path;
    extraGroups = [
      "wheel"
      "dialout"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    alejandra
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "24.11";
}
