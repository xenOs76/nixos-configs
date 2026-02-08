{
  config,
  pkgs,
  ...
}: {
  # home.username = "xeno";
  # home.homeDirectory = "/home/xeno";
  # home.stateVersion = "25.11";

  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };

  catppuccin = {
    enable = true;
    accent = "maroon";
  };

  imports = [
    ./modules/home-manager/xeno-home-servers.nix
  ];

  home.packages = with pkgs; [
    alejandra
    nurl
    nixfmt-rfc-style
  ];
}
