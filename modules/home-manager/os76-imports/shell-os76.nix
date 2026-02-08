{
  pkgs,
  config,
  ...
}: let
  https-wrench-os76-file-path = ".config/https-wrench/https-wrench-os76.yaml";
in {
  home.packages = with pkgs; [
    ansible
    delta
    ghostscript_headless
    glow
    hey
    minio-client
    pass
    poppler-utils
    xsel

    # networking tools
    httpie
    curl
    mtr
    iperf3
    ldns
    aria2
    socat
    nmap

    # misc
    gawk
    zstd

    # productivity
    hugo
    glow

    # iotop # linux only
    iftop
    htop

    # system call monitoring
    strace
    # lsof

    # system tools
    ethtool
    pciutils
    usbutils
  ];

  home.file = {
    "${https-wrench-os76-file-path}".text = builtins.readFile ./files/https-wrench-os76.yaml;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # bashrcExtra = ''
    #   export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    # '';
    #
    sessionVariables = {
      PATH = "$HOME/bin:$HOME/.krew/bin:$HOME/go/bin:$HOME/bin/go/bin:$PATH";
      LC_ALL = "C.UTF-8";
      EDITOR = "vi";
      #NIXPKGS_ALLOW_UNFREE = 1;
      ANSIBLE_NOCOWS = "1";

      # disable ssh agent
      SSH_AUTH_SOCK = "";
    };

    initExtra = ''
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
      # ".." = "cd ..";
      # cat = "bat -pp";
      # cd = "z";
      # config = ''git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'';
      #
      # ls = "eza";
      # ll = "eza -lghaa --git --git-repos";
      # lltree = "eza -lgha --git --git-repos -T --total-size --git-ignore";
      # llsize = "ll --sort=size --reverse  --total-size";
      # lltime = "ll --sort=time --reverse";
      #
      # gst = "git status";
      # gwt = "git worktree";
      # gwt-list = "git worktree list";
      # gwt-add = "git worktree add";
      # gwt-remove = "git worktree remove";
      # gdiff = "git diff";
      # lgit = "lazygit";

      #vi = "nvim"; # let nixvim manage this

      # k = "kubectl";
      # kubectl = "kubecolor";
      # nokube = "kubectx -u";
      # ktemp-shell = "kubectl netshoot run temp-shell";
      # kapply-f = "kubectl apply -f";
      # kdelete-f = "kubectl delete -f";
      # kaf = "kubectl apply -f ";
      # kdf = "kubectl delete -f ";
      kntime = "curl -s http://time.kn.os76.xyz | glow";

      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

      mqtt-home-sub-all = "mosquitto_sub -h mqtt.home.arpa -t '#'";

      tfswitch = "tfswitch -b ~/bin/terraform";

      # https://github.com/caddy-dns/powerdns/issues/4
      xcaddy-build-with-pdns = "xcaddy build v2.9.1 --with github.com/caddy-dns/powerdns@v1.0.1";

      #nixvim = "nix run git+https://git.priv.os76.xyz/xeno/nixvim";
      https-wrench-docker = "docker run --rm registry.0.os76.xyz/xeno/https-wrench:latest";
      requests-os76 = "https-wrench requests --config ${https-wrench-os76-file-path}";
    };
  };
}
