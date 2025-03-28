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
    ansible
    ansible-lint
    #    slack
    #    element-desktop
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
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

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
    colors = {
      "bg+" = "#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284";
      fg = "#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf";
      marker = "#babbf1,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284";
      selected-bg = "#51576d";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      map-syntax = [
        "*.jenkinsfile:Groovy"
        "*.props:Java Properties"
      ];
      pager = "less -FR";
      theme = "Catppuccin Frappe";
      style = "plain";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
    themes = {
      "Catppuccin Frappe" = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
          hash = "sha256-s0CHTihXlBMCKmbBBb8dUhfgOOQu9PBCQ+uviy7o47w=";
        };
        file = "themes/Catppuccin Frappe.tmTheme";
      };
    };
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

      hugo-start = "cd /Users/gcivirella/Git/github/how-i-did-it && hugo server -D";
      mqtt-home-sub-all = "mosquitto_sub -h mqtt.home.arpa -t '#'";

      tfswitch = "tfswitch -b ~/bin/terraform";

      whatismyip = "curl -4 ipinfo.io/ip";
      whatismyipv6 = "curl -6 https://ipv6.icanhazip.com";
      whatismyip-on-aws = "curl -4 https://checkip.amazonaws.com/";

      alias-from-flake = "echo 'this is a flake managed bash alias'";
      #nixvim = "nix run git+https://git.priv.os76.xyz/xeno/nixvim";
    };
  };

  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    settings = {
      theme = "catppuccin-macchiato";
      themes = {
        catppuccin-macchiato = {
          bg = "#5b6078";
          fg = "#cad3f5";
          red = "#ed8796";
          green = "#a6da95";
          blue = "#8aadf4";
          yellow = "#eed49f";
          magenta = "#f5bde6";
          orange = "#f5a97f";
          cyan = "#91d7e3";
          black = "#1e2030";
          white = "#cad3f5";
        };
      };
    };
  };
}
