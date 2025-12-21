{
  pkgs,
  config,
  ...
}: {
  home.username = "xeno";
  home.homeDirectory = "/home/xeno";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  xdg.enable = true;
  programs.bash.enable = true;

  sops = {
    age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    defaultSopsFile = ./secrets/users/xeno/secrets.yaml;
    secrets = {
      description = {
        path = "${config.home.homeDirectory}/.sops_xeno_description";
      };
      aws_config = {
        path = "${config.home.homeDirectory}/.aws/config";
      };
      aws_credentials = {
        path = "${config.home.homeDirectory}/.aws/credentials";
      };
      ssh_config = {
        path = "${config.home.homeDirectory}/.ssh/config";
      };
    };
  };

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

  catppuccin = {
    enable = true;
    flavor = "frappe";
    accent = "mauve";
    cursors.enable = false;
    chromium.enable = true;
    element-desktop.enable = true;
    firefox.enable = true;
    starship.enable = true;
    thunderbird.enable = true;
    yazi.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Zeno Belli";
    userEmail = "xeno@os76.xyz";
  };
}
