{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    #    ../../modules/nixos/default.nix
    #    ../../modules/nixos/slim
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  security.sudo.wheelNeedsPassword = false;

  ## Use the GRUB 2 boot loader.
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
      cryptDataPv UUID=bfadeb78-06fa-4ee3-9243-1abcb6f3ca84 /etc/slim_sda1_luks.key
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

  # # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.theme = "catppuccin-mocha";
  # services.displayManager.defaultSession = "plasma";
  # services.desktopManager.plasma6.enable = true;
  #
  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xeno = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    alejandra
    #    kdePackages.sddm-kcm
    #    catppuccin-sddm
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
