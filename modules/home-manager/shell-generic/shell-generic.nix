{pkgs, ...}: {
  home.packages = with pkgs; [
    # Nix essentials
    alejandra
    cachix
    nix-prefetch-git
    nixfmt-rfc-style
    nurl
    statix

    # shell essentials
    autorestic
    awscli2
    bat
    btop
    coreutils-full
    curl
    dnsutils
    doggo
    eza
    fd
    file
    findutils
    fzf
    git
    gnugrep
    gnupg
    gnused
    gnutar
    gum
    htop
    httpie
    ipcalc
    jq
    lazygit
    lsof
    mariadb
    mutt
    openssl
    p7zip
    pwgen
    restic
    ripgrep
    saml2aws
    tree
    unzip
    which
    xz
    yazi
    zellij
    zip
    zoxide

    # dev essentials
    yamlfix

    opentofu
    tflint
    tflint-plugins.tflint-ruleset-aws

    go
    golangci-lint

    uv
    (python313.withPackages (ps: [
      ps.boto3
      ps.botocore
      ps.packaging
      ps.pylint
      ps.pylint-venv
      ps.requests
      ps.rsa
      ps.urllib3
      ps.pyyaml
    ]))

    # fonts
    fira-code
    hack-font
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.terminess-ttf
    noto-fonts

    # AI
    gemini-cli
    opencode
  ];

  programs = {
    bash = {
      sessionVariables = {
        # NIXPKGS_ALLOW_UNFREE = 1;
        GUM_FORMAT_THEME = "tokyo-night";
      };
      shellAliases = {
        ".." = "cd ..";
        cd = "z";

        cat = "bat -pp";
        man = "batman";

        config = "git --git-dir=\"$HOME/.dotfiles/\" --work-tree=\"$HOME\"";
        vi = "nvim";
        iv = "vi";

        now = "date";
        utcnow = "date -u";
        date-utc = "date -u";

        whatismyip = "curl -4 ipinfo.io/ip";
        whatismyipv6 = "curl -6 https://ipv6.icanhazip.com";
        whatismyip-on-aws = "curl -4 https://checkip.amazonaws.com/";

        docker-compose-up = "docker-compose up";
        docker-compose-down = "docker-compose down";
        docker-compose-up-build = "docker-compose up --build";

        tailscale-up = "sudo tailscale up --accept-routes";
        tailscale-down = "sudo tailscale down";
        tailscale-status = "tailscale status";

        doggo-doh = "doggo @https://cloudflare-dns.com/dns-query";
        doggo-doh-repo-os76-xyz = "doggo repo.os76.xyz @https://cloudflare-dns.com/dns-query";
        doggo-doh-git-priv-os76-xyz = "doggo git.priv.os76.xyz @https://cloudflare-dns.com/dns-query";
        doggo-doh-dnssec-git-priv-os76-xyz = "doggo --do git.priv.os76.xyz @https://cloudflare-dns.com/dns-query";

        get-direnv-config-template = "cat ~/.config/os76/direnv-template.txt";

        goreleaser-test-release = "goreleaser release --snapshot --clean";
        goreleaser-release = "goreleaser release --clean";

        zellij-list-and-attach = "zellij a $(zellij ls --no-formatting | awk '{ print $1 }'| fzf)";
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    btop = {
      enable = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      defaultCommand = "fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build} --type f --max-depth 3";
      defaultOptions = [
        "--layout=reverse"
        "--height 80%"
        # "--preview 'bat --color=always {}' "
        "--multi"
        "--border-label='FZF picker'"
        "--border rounded"
        "--prompt '∷ '"
        "--pointer ▶"
        "--marker ⇒"
        "$FZF_CATPPUCCIN_OPTIONS"
      ];

      # The command that gets executed as the source for fzf for the ALT-C keybinding.
      # changeDirWidgetCommand = "fzf";
      # changeDirWidgetOptions = [
      #   "--style full"
      #   "--height 60%"
      #   "--preview 'bat --color=always {}' "
      #   "--bind 'focus:transform-header:file --brief {}'"
      # ];
      #
      # Command line options for the CTRL-R keybinding.
      historyWidgetOptions = ["--height 20%"];
    };

    bat = {
      enable = true;
      config = {
        map-syntax = [
          "*.jenkinsfile:Groovy"
          "*.props:Java Properties"
        ];
        pager = "less -FR";
        style = "plain";
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };

    zellij = {
      enable = true;
      enableBashIntegration = false;

      # https://github.com/zellij-org/zellij/blob/main/zellij-utils/assets/config/default.kd
      # https://zellij.dev/documentation/keybindings.html
      # https://zellij.dev/documentation/configuration.html#configuration
      extraConfig = builtins.readFile ./files/zellij/config.kdl;
    };
  };

  home.file = {
    ".config/os76/direnv-template.txt".text = ''
      #
      #  direnv config
      #
      #  https://direnv.net/
      #  https://github.com/direnv/direnv/wiki
      #  https://github.com/nix-community/nix-direnv
      #

      #use nix
      #use flake

      #export VIRTUAL_ENV=".venv"
      #test -d $VIRTUAL_ENV || (echo 'Creating Python venv' && python -m venv $VIRTUAL_ENV && source $VIRTUAL_ENV/bin/activate && pip install -r requirements.txt && pip install -r requirements-dev.txt)
      #layout python
    '';

    # https://github.com/cufarvid/lazy-idea/tree/main
    ".ideavimrc".text = builtins.readFile (
      builtins.fetchurl {
        url = "https://raw.githubusercontent.com/cufarvid/lazy-idea/refs/heads/main/lazy-idea.vim";
        sha256 = "sha256:0q6li6hh5v2z225py25b5ykp6bhjqplw603g81lka6ihab394div";
      }
    );

    # https://github.com/ahmetb/kubectl-aliases
    ".kubectl_aliases".text = builtins.readFile (
      builtins.fetchurl {
        url = "https://raw.githubusercontent.com/ahmetb/kubectl-aliases/refs/heads/master/.kubectl_aliases";
        sha256 = "sha256:1acyhhhbfxz17ch77nf26x0cj4immsl6drcpwwbklrl49n9gm9ia";
      }
    );
  };
}
