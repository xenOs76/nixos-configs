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
    television
    tldr
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
    lsof

    # system tools
    ethtool
    pciutils
    usbutils
  ];

  home.file = {
    "${https-wrench-os76-file-path}".text = builtins.readFile ./files/https-wrench-os76.yaml;
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      sessionVariables = {
        # PATH = "$HOME/bin:$HOME/.krew/bin:$HOME/go/bin:$HOME/bin/go/bin:$PATH";
        LC_ALL = "C.UTF-8";
        #NIXPKGS_ALLOW_UNFREE = 1;
        # ANSIBLE_NOCOWS = "1";

        # disable ssh agent
        # SSH_AUTH_SOCK = "";
      };

      initExtra = ''
          ### Exports ###

          export EDITOR="vi"
          export ANSIBLE_NOCOWS="1"
          export NIXPKGS_ALLOW_UNFREE="1"

          # disable ssh agent
          SSH_AUTH_SOCK=""

          export GEMINI_API_KEY_FILE="/home/xeno/.config/gemini_api_key_cli_testing"
          test -f $GEMINI_API_KEY_FILE && export GEMINI_API_KEY=$(cat $GEMINI_API_KEY_FILE)
          export AVANTE_GEMINI_API_KEY=$GEMINI_API_KEY

          # https://www.reddit.com/r/pop_os/comments/1pmpqga/firefox_freezing_in_pop_os_2404/
          export MOZ_ENABLE_WAYLAND="1"
          ###############

          ### Completions ###
          command -v glow &>/dev/null && eval "$(glow completion bash)"
          command -v helm &>/dev/null && eval "$(helm completion bash)"
          command -v velero &>/dev/null && eval "$(velero completion bash)"
          command -v aws_completer &>/dev/null && complete -C 'aws_completer' aws
          # which https-wrench &>/dev/null && eval "$(https-wrench completion bash)"
          ##################

          test -d ~/bin || mkdir ~/bin
          test -d ~/.krew/bin || mkdir -p ~/.krew/bin
          #test -f ~/.krew/bin/kubectl-netshoot && eval "$(kubectl netshoot completion bash)"

          test -f ~/.kubectl_aliases && source ~/.kubectl_aliases

        # HTTPS-Wrench test variables
         test -f ~/.config/https-wrench/jwtinfo_test_auth0_req_values.json && export JWTINFO_TEST_AUTH0=$(cat ~/.config/https-wrench/jwtinfo_test_auth0_req_values.json)
         test -f ~/.config/https-wrench/jwtinfo_test_keycloak_req_values.json && export JWTINFO_TEST_KEYCLOAK=$(cat ~/.config/https-wrench/jwtinfo_test_keycloak_req_values.json)
      '';

      shellAliases = {
        kntime = "curl -s http://time.kn.os76.xyz | glow";

        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

        mqtt-home-sub-all = "mosquitto_sub -h mqtt.home.arpa -t '#'";

        tfswitch = "tfswitch -b ~/bin/terraform";

        # https://github.com/caddy-dns/powerdns/issues/4
        xcaddy-build-with-pdns = "xcaddy build v2.9.1 --with github.com/caddy-dns/powerdns@v1.0.1";

        https-wrench-docker = "docker run --rm registry.0.os76.xyz/xeno/https-wrench:latest";
        requests-os76 = "https-wrench requests --config ${https-wrench-os76-file-path}";
      };
    };
  };
}
