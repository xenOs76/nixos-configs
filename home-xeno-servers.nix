{
  config,
  pkgs,
  ...
}: {
  # home.username = "xeno";
  # home.homeDirectory = "/home/xeno";
  # home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  imports = [
    ./modules/home-manager/xeno-home-servers.nix
  ];

  home.packages = with pkgs; [
    alejandra
    nurl
    nixfmt-rfc-style
  ];

  programs.git = {
    enable = true;
    userName = "Zeno Belli";
    userEmail = "xeno@os76.xyz";
  };
}
