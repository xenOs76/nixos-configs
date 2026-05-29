{
  pkgs,
  pkgsUnstable,
  ...
}: {
  home.packages = with pkgs; [
    pkgsUnstable.devenv
    statix
    commitizen

    ### Editors
    #zed-editor # hm managed
    # jetbrains.idea-oss

    # Make / Iot
    esphome
    screen
    arduino
    fritzing
    mosquitto
    mqttx
    bossa

    ### Languages
    gcc15
    gnumake42

    gci
    go
    gofumpt
    gomodifytags
    gore
    goreleaser
    gotest
    gotools
    govulncheck
    pkgsUnstable.golangci-lint
    # delve
    # golines
    # gopls
    # impl
    # tinygo

    ansible
    # ansible-lint  # https://github.com/nixos/nixpkgs/issues/460422

    # Python: check Nix Python env definition in shell-generic.nix
    ruff
    uv
    # CirtuitPython
    thonny
    circup

    #terraform
    opentofu
    nodejs_24

    # shell linter
    shellcheck
    yamllint
    markdownlint-cli2

    ## Utils
    # SBOM creation
    syft
    # Gihub actions pinning
    pinact
    # Sonarqube scanner
    sonar-scanner-cli-minimal
    # Taskfile.yml processin
    go-task
  ];

  programs = {
    bash = {
      shellAliases = {
        # golang-validation step 1: quick unit tests
        go-test = "gotest ./...";
        # CI-matching coverage (https-wrench codeChecks.yml)
        go-test-ci = "gotest ./... -coverprofile=./cover.out -covermode=atomic -coverpkg=./...";
        go-test-verbose = "gotest -v ./... -coverprofile=./cover.out -covermode=atomic -coverpkg=./...";
        # golang-validation step 3: parallel stress validation
        go-test-stress = "gotest ./... -coverprofile=./cover.out -covermode=atomic -coverpkg=./... -count=20";
        go-test-stress-race = "gotest ./... -coverprofile=./cover.out -covermode=atomic -coverpkg=./... -count=20 -race";
        go-test-coverage-html = "go tool cover -html=cover.out";
        go-test-coverage-text = "go tool cover -func=cover.out";
        go-test-vulnerabilities = "govulncheck ./...";
        # golang-validation mandatory execution: tests, lint, parallel stress
        go-validate = "go-test && golangci-lint-run && go-test-stress";
        go-update-deps = "go get -u && go mod tidy";
        golangci-lint-run = "golangci-lint run";
        golangci-lint-run-fix = "golangci-lint run --fix";
        golangci-lint-run-verbose = "golangci-lint -v run";
      };
    };
    zed-editor = {
      enable = false;
      installRemoteServer = true;

      extraPackages = with pkgs; [
        nixd
        shellcheck
        shfmt
        ansible
        ansible-lint
      ];

      extensions = [
        "nix"
        "terraform"
        "tflint"
        "csv"
        "sql"
        "rainbow-csv"
        "ansible"
        "helm"
        "Caddyfile"
        "make"
        "golangci-lint"
        "gosum"
        "go-snippets"
        "gotmpl"
        "dockerfile"
        "docker-compose"
        "ghostty"
        "github-actions"
        "nginx"
        "pylsp"
        "pytest-language-server"
        "python-refactoring"
        "python-requirements"
        "python-snippets"
        "rpmspec"
        "ssh-config"
      ];

      userSettings = {
        ui_font_size = 21.0;
        buffer_font_size = 19;
        buffer_line_height = "comfortable";
        agent_ui_font_size = 21.0;
        ui_font_family = "JetBrains Mono";
        buffer_font_family = "JetBrains Mono";

        terminal = {
          font_family = "JetBrainsMono Nerd Font";
          font_size = 19;
          copy_on_select = true;
        };

        diagnostics = {
          inline = {
            enabled = true;
          };
        };

        autosave = "on_focus_change";
        auto_update = false;
        snippet_sort_order = "inline";
        show_completions_on_input = true;
        show_completion_documentation = true;
        auto_signature_help = false;
        show_signature_help_after_edits = false;
        inline_code_actions = true;
        diagnostics_max_severity = null;
        lsp_document_colors = "inlay";
        completion_menu_scrollbar = "never";
        load_direnv = "direct";

        features = {
          copilot = false;
        };

        telemetry = {
          metrics = false;
        };

        vim_mode = true;

        file_types = {
          Ansible = [
            "**.ansible.yml"
            "**.ansible.yaml"
            "**/defaults/*.yml"
            "**/defaults/*.yaml"
            "**/meta/*.yml"
            "**/meta/*.yaml"
            "**/tasks/*.yml"
            "**/tasks/*.yaml"
            "**/handlers/*.yml"
            "**/handlers/*.yaml"
            "**/group_vars/*.yml"
            "**/group_vars/*.yaml"
            "**/host_vars/*.yml"
            "**/host_vars/*.yaml"
            "**/playbooks/*.yml"
            "**/playbooks/*.yaml"
            "**playbook*.yml"
            "**playbook*.yaml"
          ];
        };

        languages = {
          "Shell Script" = {
            format_on_save = "on";
            formatter = {
              external = {
                command = "shfmt";
                # // Change `--indent 2` to match your preferred tab_size
                arguments = [
                  "--filename"
                  "{buffer_path}"
                  "--indent"
                  "2"
                ];
              };
            };
          };

          Python = {
            tab_size = 4;
            formatter = "language_server";
            format_on_save = "on";
          };

          Markdown = {
            format_on_save = "on";
            remove_trailing_whitespace_on_save = false;
          };
        };

        inlay_hints = {
          enabled = true;
          show_type_hints = true;
          show_parameter_hints = true;
          show_other_hints = true;
          show_background = false;
          edit_debounce_ms = 700;
          scroll_debounce_ms = 50;
          toggle_on_modifiers_press = {
            control = false;
            shift = false;
            alt = false;
            platform = false;
            function = false;
          };
        };

        lsp = {
          ansible-language-server = {
            settings = {
              ansible = {
                path = "ansible";
              };
              executionEnvironment = {
                enabled = false;
              };
              python = {
                interpreterPath = "python3";
              };
              validation = {
                enabled = true;
                lint = {
                  enabled = true;
                  path = "ansible-lint";
                };
              };
            };
          };

          yaml-language-server = {
            settings = {
              yaml = {
                keyOrdering = false;
                schemas = {
                  # Ansible
                  "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/inventory.json" = [
                    "./inventory/*.yaml"
                    "hosts.yml"
                  ];
                  # https-wrench
                  "https://raw.githubusercontent.com/xenOs76/https-wrench/refs/heads/main/https-wrench.schema.json" = [
                    "https-wrench*.yaml"
                  ];
                };
              };
            };
          };

          gopls = {
            initialization_options = {
              hints = {
                assignVariableTypes = true;
                compositeLiteralFields = true;
                compositeLiteralTypes = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
            };
          };
        };
      };
    };
  };

  home.file = {
    # https://github.com/google/yamlfmt/blob/main/docs/config-file.md
    ".config/yamlfmt/.yamlfmt.yaml".text = ''
      formatter:
        type: basic
        include_document_start: true
        retain_line_breaks_single: true
    '';

    # https://yamllint.readthedocs.io/en/stable/configuration.html#default-configuration
    ".config/yamllint/config".text = ''
      ---

      yaml-files:
        - '*.yaml'
        - '*.yml'
        - '.yamllint'

      rules:
        anchors: enable
        braces: enable
        brackets: enable
        colons: enable
        commas: enable

        comments:
          level: warning
          ignore:
            - /workflows/*.yaml
            - /workflows/*.yml

        comments-indentation:
          level: warning

        document-end: disable

        document-start:
          level: warning

        empty-lines: enable
        empty-values: disable
        float-values: disable
        hyphens: enable
        indentation: enable
        key-duplicates: enable
        key-ordering: disable
        line-length: enable
        new-line-at-end-of-file: enable
        new-lines: enable
        octal-values: disable
        quoted-strings: disable
        trailing-spaces: enable

        truthy:
          level: warning

    '';
  };
}
