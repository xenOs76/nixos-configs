{
  pkgs,
  lib,
  config,
  os76Cfg,
  ...
}: let
  homeDir = config.home.homeDirectory;
  ensureGiteaReposScript = pkgs.writeShellScript "ensure-gitea-repos" ''
    set -euo pipefail
    export GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh -o BatchMode=yes -o ConnectTimeout=5"
    giteaDir="${homeDir}/git/gitea"
    notify=${lib.getExe pkgs.libnotify}
    mkdir=${pkgs.coreutils}/bin/mkdir
    rm=${pkgs.coreutils}/bin/rm
    ln=${pkgs.coreutils}/bin/ln
    timeout=${pkgs.coreutils}/bin/timeout
    git=${pkgs.git}/bin/git

    "$mkdir" -p "$giteaDir"
    for repo in agents llm-wiki; do
      if [ -d "$giteaDir/$repo" ] && [ ! -d "$giteaDir/$repo/.git" ]; then
        "$rm" -rf "$giteaDir/$repo"
      fi
      if [ ! -d "$giteaDir/$repo/.git" ]; then
        if ! "$timeout" 15 "$git" clone \
          "git@git.priv.os76.xyz:xeno/$repo.git" "$giteaDir/$repo"; then
          "$notify" -u critical \
            "Gitea clone failed" \
            "Could not clone $repo (will retry next login)" || true
        fi
      fi
    done
    if [ -d "$giteaDir/agents" ]; then
      "$ln" -sfn "$giteaDir/agents" "${homeDir}/.agents"
    fi
    exit 0
  '';
in {
  home = {
    username = "xeno";
    homeDirectory = "/home/xeno";
    stateVersion = "26.05";
    # Bare `virsh` defaults to qemu:///session; preprod domains live on system.
    sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";
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

  home.packages = with pkgs; [
    nurl
    nixfmt
    trivy
  ];

  # Clone missing private Gitea repos after graphical login (not during HM boot activation).
  systemd.user.services.ensure-gitea-repos = {
    Unit = {
      Description = "Clone missing private Gitea repos";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${ensureGiteaReposScript}";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
