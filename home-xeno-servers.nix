{
  config,
  pkgs,
  ...
}: {
  home.username = "xeno";
  home.homeDirectory = "/home/xeno";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  imports = [
    ./modules/home-manager/xeno-home-servers.nix
    # ./modules/nixos/nixvim-full
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
