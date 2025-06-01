{pkgs, ...}: {
  home.username = "xeno";
  home.homeDirectory = "/home/xeno";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  sops = {
    age.sshKeyPaths = ["/home/xeno/.ssh/id_ed25519"];
    defaultSopsFile = ./secrets/users/xeno/secrets.yaml;
    secrets = {
      description = {
        path = "/home/xeno/.sops_xeno_description";
      };
      aws_config = {
        path = "/home/xeno/.aws/config";
      };
      aws_credentials = {
        path = "/home/xeno/.aws/credentials";
      };
      ssh_config = {
        path = "/home/xeno/.ssh/config";
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

  programs.git = {
    enable = true;
    userName = "Zeno Belli";
    userEmail = "xeno@os76.xyz";
  };
}
