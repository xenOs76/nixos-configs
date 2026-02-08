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

    (python313.withPackages (ps: [
      ps.boto3
      ps.botocore
      ps.packaging
      ps.pylint
      ps.pylint-venv
      ps.requests
      ps.rsa
      ps.urllib3
    ]))

    # fonts
    fira-code
    hack-font
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.terminess-ttf
    noto-fonts
  ];

  programs = {
    bash = {
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
      };
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.btop = {
    enable = true;
  };

  programs.fzf = {
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

  programs.bat = {
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

  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
  };

  home.file = {
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
