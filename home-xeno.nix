{
  pkgs,
  config,
  os76Cfg,
  antigravity,
  ...
}: {
  home = {
    username = "xeno";
    homeDirectory = "/home/xeno";
    stateVersion = "25.11";
  };

  xdg.enable = true;
  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };

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
    {inherit os76Cfg;}
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
    antigravity.packages.${pkgs.system}.default
  ];
}
