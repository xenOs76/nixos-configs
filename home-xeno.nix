{pkgs, ...}: {
  home.username = "xeno";
  home.homeDirectory = "/home/xeno";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ./modules/home-manager
  ];

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

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
