{pkgs, ...}: {
  home.packages = with pkgs; [
    # nix related
    alejandra
    nurl
    nix-output-monitor

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    #neovim # will override nixvim conf from nixOs
    ripgrep
    yq-go
    lazygit
    git
    delta
    lf
    fd
    yazi
    zoxide
    fzf
    bat
    glow
    eza
    jq
    unzip
    awscli2
    minio-client
    ansible
    pass
    gnupg
    pwgen
    poppler_utils
    ghostscript_headless
    gum
    hey
    xsel

    # networking tools
    httpie
    curl
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # productivity
    hugo
    glow

    btop
    iotop
    iftop
    htop

    # system call monitoring
    strace
    ltrace
    lsof

    # system tools
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # development
    go
  ];

  catppuccin.lazygit.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  catppuccin.zellij.enable = true;
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
  };

  catppuccin.fzf.enable = true;
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultCommand = "fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build} --type f";
    defaultOptions = [
      "--layout=reverse"
      "--height 40%"
      "--preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"
      "--multi"
    ];
    fileWidgetOptions = [
      "--preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"
    ];
    historyWidgetOptions = ["--height 20%"];
  };

  catppuccin.bat.enable = true;
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

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  home.file = {
    ".kubectl_aliases".text = builtins.readFile (
      builtins.fetchurl {
        url = "https://raw.githubusercontent.com/ahmetb/kubectl-aliases/refs/heads/master/.kubectl_aliases";
        sha256 = "sha256:1acyhhhbfxz17ch77nf26x0cj4immsl6drcpwwbklrl49n9gm9ia";
      }
    );
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    sessionVariables = {
      PATH = "$HOME/bin:$HOME/.krew/bin:$HOME/go/bin:$HOME/bin/go/bin:$PATH";
      LC_ALL = "C.UTF-8";
      EDITOR = "nvim";
      #NIXPKGS_ALLOW_UNFREE = 1;
      ANSIBLE_NOCOWS = "1";

      # https://medium.com/@pseguel/problems-with-python-on-macos-6b4aab58c765
      #OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";

      #STARSHIP_CONFIG = ~/.config/starship.toml;

      # disable ssh agent
      SSH_AUTH_SOCK = "";
    };

    initExtra = ''

      # let Home Manager (Standalone) manage the shell environment
      #. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

      #set -o vi

      test -d ~/bin || mkdir ~/bin
      test -d ~/.krew/bin || mkdir -p ~/.krew/bin
      test -f ~/.krew/bin/kubectl-netshoot && eval "$(kubectl netshoot completion bash)"

      export GEMINI_API_KEY_FILE="/home/xeno/.config/gemini_api_key_cli_testing"
      test -f $GEMINI_API_KEY_FILE && export GEMINI_API_KEY=$(cat $GEMINI_API_KEY_FILE)
      export AVANTE_GEMINI_API_KEY=$GEMINI_API_KEY

      # which https-wrench &>/dev/null && eval "$(https-wrench completion bash)"
      complete -C 'aws_completer' aws
      eval "$(glow completion bash)"
      eval "$(helm completion bash)"
      eval "$(velero completion bash)"

      source ~/.kubectl_aliases

    '';

    shellAliases = {
      ".." = "cd ..";
      cat = "bat -pp";
      man = "batman";
      cd = "z";
      config = ''git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'';
      ls = "eza";
      ll = "eza -lghaa --git --git-repos";
      lltree = "eza -lgha --git --git-repos -T --total-size --git-ignore";
      llsize = "ll --sort=size --reverse  --total-size";
      lltime = "ll --sort=time --reverse";

      gst = "git status";
      gwt = "git worktree";
      gwt-list = "git worktree list";
      gwt-add = "git worktree add";
      gwt-remove = "git worktree remove";
      gdiff = "git diff";
      lgit = "lazygit";

      vi = "nvim";

      k = "kubectl";
      kubectl = "kubecolor";
      nokube = "kubectx -u";
      ktemp-shell = "kubectl netshoot run temp-shell";
      kapply-f = "kubectl apply -f";
      kdelete-f = "kubectl delete -f";
      kaf = "kubectl apply -f ";
      kdf = "kubectl delete -f ";
      kntime = "curl -s http://time.kn.os76.xyz | glow";

      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

      mqtt-home-sub-all = "mosquitto_sub -h mqtt.home.arpa -t '#'";

      tfswitch = "tfswitch -b ~/bin/terraform";

      whatismyip = "curl -4 ipinfo.io/ip";
      whatismyipv6 = "curl -6 https://ipv6.icanhazip.com";
      whatismyip-on-aws = "curl -4 https://checkip.amazonaws.com/";

      docker-compose-up = "docker-compose up";
      docker-compose-down = "docker-compose down";
      docker-compose-up-build = "docker-compose up --build";

      tailscale-up = "sudo tailscale up --accept-routes";
      tailscale-down = "sudo tailscale down";
      tailscale-status = "tailscale status";

      # https://github.com/caddy-dns/powerdns/issues/4
      xcaddy-build-with-pdns = "xcaddy build v2.9.1 --with github.com/caddy-dns/powerdns@v1.0.1";

      #nixvim = "nix run git+https://git.priv.os76.xyz/xeno/nixvim";
      https-wrench-docker = "docker run --rm registry.0.os76.xyz/xeno/https-wrench:latest";
    };
  };
}
