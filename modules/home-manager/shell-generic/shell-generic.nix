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
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.terminess-ttf
    noto-fonts
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
      extraConfig = ''
        keybinds clear-defaults=true {
            locked {
                bind "Ctrl Alt g" { SwitchToMode "normal"; }
            }
            pane {
                bind "left" { MoveFocus "left"; }
                bind "down" { MoveFocus "down"; }
                bind "up" { MoveFocus "up"; }
                bind "right" { MoveFocus "right"; }
                bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
                bind "d" { NewPane "down"; SwitchToMode "normal"; }
                bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "normal"; }
                bind "f" { ToggleFocusFullscreen; SwitchToMode "normal"; }
                bind "h" { MoveFocus "left"; }
                bind "i" { TogglePanePinned; SwitchToMode "normal"; }
                bind "j" { MoveFocus "down"; }
                bind "k" { MoveFocus "up"; }
                bind "l" { MoveFocus "right"; }
                bind "n" { NewPane; SwitchToMode "normal"; }
                bind "p" { SwitchFocus; }
                bind "Ctrl Alt p" { SwitchToMode "normal"; }
                bind "r" { NewPane "right"; SwitchToMode "normal"; }
                bind "s" { NewPane "stacked"; SwitchToMode "normal"; }
                bind "w" { ToggleFloatingPanes; SwitchToMode "normal"; }
                bind "z" { TogglePaneFrames; SwitchToMode "normal"; }
            }
            tab {
                bind "left" { GoToPreviousTab; }
                bind "down" { GoToNextTab; }
                bind "up" { GoToPreviousTab; }
                bind "right" { GoToNextTab; }
                bind "1" { GoToTab 1; SwitchToMode "normal"; }
                bind "2" { GoToTab 2; SwitchToMode "normal"; }
                bind "3" { GoToTab 3; SwitchToMode "normal"; }
                bind "4" { GoToTab 4; SwitchToMode "normal"; }
                bind "5" { GoToTab 5; SwitchToMode "normal"; }
                bind "6" { GoToTab 6; SwitchToMode "normal"; }
                bind "7" { GoToTab 7; SwitchToMode "normal"; }
                bind "8" { GoToTab 8; SwitchToMode "normal"; }
                bind "9" { GoToTab 9; SwitchToMode "normal"; }
                bind "[" { BreakPaneLeft; SwitchToMode "normal"; }
                bind "]" { BreakPaneRight; SwitchToMode "normal"; }
                bind "b" { BreakPane; SwitchToMode "normal"; }
                bind "h" { GoToPreviousTab; }
                bind "j" { GoToNextTab; }
                bind "k" { GoToPreviousTab; }
                bind "l" { GoToNextTab; }
                bind "n" { NewTab; SwitchToMode "normal"; }
                bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
                bind "s" { ToggleActiveSyncTab; SwitchToMode "normal"; }
                bind "Ctrl Alt t" { SwitchToMode "normal"; }
                bind "x" { CloseTab; SwitchToMode "normal"; }
                bind "tab" { ToggleTab; }
            }
            resize {
                bind "left" { Resize "Increase left"; }
                bind "down" { Resize "Increase down"; }
                bind "up" { Resize "Increase up"; }
                bind "right" { Resize "Increase right"; }
                bind "+" { Resize "Increase"; }
                bind "-" { Resize "Decrease"; }
                bind "=" { Resize "Increase"; }
                bind "H" { Resize "Decrease left"; }
                bind "J" { Resize "Decrease down"; }
                bind "K" { Resize "Decrease up"; }
                bind "L" { Resize "Decrease right"; }
                bind "h" { Resize "Increase left"; }
                bind "j" { Resize "Increase down"; }
                bind "k" { Resize "Increase up"; }
                bind "l" { Resize "Increase right"; }
                bind "Ctrl Alt n" { SwitchToMode "normal"; }
            }
            move {
                bind "left" { MovePane "left"; }
                bind "down" { MovePane "down"; }
                bind "up" { MovePane "up"; }
                bind "right" { MovePane "right"; }
                bind "h" { MovePane "left"; }
                bind "Ctrl Alt h" { SwitchToMode "normal"; }
                bind "j" { MovePane "down"; }
                bind "k" { MovePane "up"; }
                bind "l" { MovePane "right"; }
                bind "n" { MovePane; }
                bind "p" { MovePaneBackwards; }
                bind "tab" { MovePane; }
            }
            scroll {
                bind "e" { EditScrollback; SwitchToMode "normal"; }
                bind "s" { SwitchToMode "entersearch"; SearchInput 0; }
                bind "Ctrl Alt s" { SwitchToMode "normal"; }
            }
            search {
                bind "c" { SearchToggleOption "CaseSensitivity"; }
                bind "n" { Search "down"; }
                bind "o" { SearchToggleOption "WholeWord"; }
                bind "p" { Search "up"; }
                bind "Ctrl s" { SwitchToMode "normal"; }
                bind "w" { SearchToggleOption "Wrap"; }
            }
            session {
                bind "a" {
                    LaunchOrFocusPlugin "zellij:about" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "normal"
                }
                bind "c" {
                    LaunchOrFocusPlugin "configuration" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "normal"
                }
                bind "Ctrl Alt o" { SwitchToMode "normal"; }
                bind "p" {
                    LaunchOrFocusPlugin "plugin-manager" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "normal"
                }
                bind "s" {
                    LaunchOrFocusPlugin "zellij:share" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "normal"
                }
                bind "w" {
                    LaunchOrFocusPlugin "session-manager" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "normal"
                }
            }
            shared_among "normal" "locked" {
                bind "Alt Super left" { MoveFocusOrTab "left"; }
                bind "Alt Super down" { MoveFocus "down"; }
                bind "Alt Super up" { MoveFocus "up"; }
                bind "Alt Super right" { MoveFocusOrTab "right"; }
                bind "Alt Super +" { Resize "Increase"; }
                bind "Alt Super -" { Resize "Decrease"; }
                bind "Alt Super =" { Resize "Increase"; }
                bind "Alt Super [" { PreviousSwapLayout; }
                bind "Alt Super ]" { NextSwapLayout; }
                bind "Alt Super f" { ToggleFloatingPanes; }
                bind "Alt Super h" { MoveFocusOrTab "left"; }
                bind "Alt Super i" { MoveTab "left"; }
                bind "Alt Super j" { MoveFocus "down"; }
                bind "Alt Super k" { MoveFocus "up"; }
                bind "Alt Super l" { MoveFocusOrTab "right"; }
                bind "Alt Super n" { NewPane; }
                bind "Alt Super o" { MoveTab "right"; }
            }
            shared_except "locked" {
                bind "Alt p" { TogglePaneInGroup; }
                bind "Alt Shift p" { ToggleGroupMarking; }
            }
            shared_except "locked" "entersearch" "renametab" "renamepane" "move" "prompt" "tmux" {
                bind "Ctrl Alt h" { SwitchToMode "move"; }
            }
            shared_except "locked" "entersearch" "renametab" "renamepane" "prompt" "tmux" {
                bind "Ctrl Alt g" { SwitchToMode "locked"; }
                bind "Ctrl Alt q" { Quit; }
            }
            shared_except "locked" "entersearch" "renametab" "renamepane" "session" "prompt" "tmux" {
                bind "Ctrl Alt o" { SwitchToMode "session"; }
            }
            shared_except "locked" "scroll" "search" "tmux" {
                bind "Ctrl b" { SwitchToMode "tmux"; }
            }
            shared_except "locked" "scroll" "entersearch" "renametab" "renamepane" "prompt" "tmux" {
                bind "Ctrl Alt s" { SwitchToMode "scroll"; }
            }
            shared_except "locked" "tab" "entersearch" "renametab" "renamepane" "prompt" "tmux" {
                bind "Ctrl Alt t" { SwitchToMode "tab"; }
            }
            shared_except "locked" "pane" "entersearch" "renametab" "renamepane" "prompt" "tmux" {
                bind "Ctrl Alt p" { SwitchToMode "pane"; }
            }
            shared_except "locked" "resize" "entersearch" "renametab" "renamepane" "prompt" "tmux" {
                bind "Ctrl Alt n" { SwitchToMode "resize"; }
            }
            shared_except "normal" "locked" {
                bind "Alt left" { MoveFocusOrTab "left"; }
                bind "Alt down" { MoveFocus "down"; }
                bind "Alt up" { MoveFocus "up"; }
                bind "Alt right" { MoveFocusOrTab "right"; }
                bind "Alt +" { Resize "Increase"; }
                bind "Alt -" { Resize "Decrease"; }
                bind "Alt =" { Resize "Increase"; }
                bind "Alt [" { PreviousSwapLayout; }
                bind "Alt ]" { NextSwapLayout; }
                bind "Alt f" { ToggleFloatingPanes; }
                bind "Alt h" { MoveFocusOrTab "left"; }
                bind "Alt i" { MoveTab "left"; }
                bind "Alt j" { MoveFocus "down"; }
                bind "Alt k" { MoveFocus "up"; }
                bind "Alt l" { MoveFocusOrTab "right"; }
                bind "Alt n" { NewPane; }
                bind "Alt o" { MoveTab "right"; }
            }
            shared_except "normal" "locked" "entersearch" {
                bind "enter" { SwitchToMode "normal"; }
            }
            shared_except "normal" "locked" "entersearch" "renametab" "renamepane" {
                bind "esc" { SwitchToMode "normal"; }
            }
            shared_among "pane" "tmux" {
                bind "x" { CloseFocus; SwitchToMode "normal"; }
            }
            shared_among "scroll" "search" {
                bind "PageDown" { PageScrollDown; }
                bind "PageUp" { PageScrollUp; }
                bind "left" { PageScrollUp; }
                bind "down" { ScrollDown; }
                bind "up" { ScrollUp; }
                bind "right" { PageScrollDown; }
                bind "Ctrl b" { PageScrollUp; }
                bind "Ctrl c" { ScrollToBottom; SwitchToMode "normal"; }
                bind "d" { HalfPageScrollDown; }
                bind "Ctrl f" { PageScrollDown; }
                bind "h" { PageScrollUp; }
                bind "j" { ScrollDown; }
                bind "k" { ScrollUp; }
                bind "l" { PageScrollDown; }
                bind "u" { HalfPageScrollUp; }
            }
            entersearch {
                bind "Ctrl c" { SwitchToMode "scroll"; }
                bind "esc" { SwitchToMode "scroll"; }
                bind "enter" { SwitchToMode "search"; }
            }
            shared_among "entersearch" "renametab" "renamepane" "prompt" "tmux" {
                bind "Ctrl g" { SwitchToMode "locked"; }
                bind "Ctrl h" { SwitchToMode "move"; }
                bind "Ctrl n" { SwitchToMode "resize"; }
                bind "Ctrl o" { SwitchToMode "session"; }
                bind "Ctrl p" { SwitchToMode "pane"; }
                bind "Ctrl q" { Quit; }
                bind "Ctrl s" { SwitchToMode "scroll"; }
                bind "Ctrl t" { SwitchToMode "tab"; }
            }
            renametab {
                bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
            }
            shared_among "renametab" "renamepane" {
                bind "Ctrl c" { SwitchToMode "normal"; }
            }
            renamepane {
                bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
            }
            shared_among "session" "tmux" {
                bind "d" { Detach; }
            }
            tmux {
                bind "left" { MoveFocus "left"; SwitchToMode "normal"; }
                bind "down" { MoveFocus "down"; SwitchToMode "normal"; }
                bind "up" { MoveFocus "up"; SwitchToMode "normal"; }
                bind "right" { MoveFocus "right"; SwitchToMode "normal"; }
                bind "space" { NextSwapLayout; }
                bind "\"" { NewPane "down"; SwitchToMode "normal"; }
                bind "%" { NewPane "right"; SwitchToMode "normal"; }
                bind "," { SwitchToMode "renametab"; }
                bind "[" { SwitchToMode "scroll"; }
                bind "Ctrl b" { Write 2; SwitchToMode "normal"; }
                bind "c" { NewTab; SwitchToMode "normal"; }
                bind "h" { MoveFocus "left"; SwitchToMode "normal"; }
                bind "j" { MoveFocus "down"; SwitchToMode "normal"; }
                bind "k" { MoveFocus "up"; SwitchToMode "normal"; }
                bind "l" { MoveFocus "right"; SwitchToMode "normal"; }
                bind "n" { GoToNextTab; SwitchToMode "normal"; }
                bind "o" { FocusNextPane; }
                bind "p" { GoToPreviousTab; SwitchToMode "normal"; }
                bind "z" { ToggleFocusFullscreen; SwitchToMode "normal"; }
            }
        }

        // Plugin aliases - can be used to change the implementation of Zellij
        // changing these requires a restart to take effect
        plugins {
            about location="zellij:about"
            compact-bar location="zellij:compact-bar"
            configuration location="zellij:configuration"
            filepicker location="zellij:strider" {
                cwd "/"
            }
            plugin-manager location="zellij:plugin-manager"
            session-manager location="zellij:session-manager"
            status-bar location="zellij:status-bar"
            strider location="zellij:strider"
            tab-bar location="zellij:tab-bar"
            welcome-screen location="zellij:session-manager" {
                welcome_screen true
            }
        }

        // Plugins to load in the background when a new session starts
        // eg. "file:/path/to/my-plugin.wasm"
        // eg. "https://example.com/my-plugin.wasm"
        load_plugins {
        }
        web_client {
            font "monospace"
        }
      '';
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
