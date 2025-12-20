{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    devenv
    commitizen

    ### Editors
    #zed-editor # see below
    jetbrains.idea-community-bin
    # jetbrains.pycharm-community-bin
    thonny

    # Make / Iot
    circup
    esphome
    screen
    arduino
    fritzing
    mosquitto
    mqttx
    bossa

    ### Languages
    go
    tinygo
    gopls
    gotools
    golangci-lint
    gofumpt
    gomodifytags
    golines
    gci
    impl
    delve

    (python3.withPackages (
      ps: with ps; [
        rsa
        boto3
        boto3-stubs
        botocore
        packaging
        pip
        pylint
        urllib3
        types-urllib3
        pipx
        twine
        distutils
      ]
    ))

    ansible
    # ansible-lint  # https://github.com/nixos/nixpkgs/issues/460422
    poetry

    #terraform
    opentofu
    tfswitch

    ### Format/Lint
    lua-language-server
    black
    stylua
    prettierd
    nil
    nixd
    yamlfmt
    shellcheck
    shfmt
    terraform-ls
    terraform-docs
    tflint
  ];

  programs.zed-editor = {
    enable = true;
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
      ui_font_family = "Ubuntu";
      buffer_font_family = "FiraCode Nerd Font Mono";

      terminal = {
        font_family = ".ZedMono";
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
                "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/inventory.json" =
                  [
                    "./inventory/*.yaml"
                    "hosts.yml"
                  ];
                # https-wrench
                "https://raw.githubusercontent.com/xenOs76/https-wrench/refs/heads/main/https-wrench.schema.json" =
                  [
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

  home.file = {
    # https://github.com/google/yamlfmt/blob/main/docs/config-file.md
    ".config/yamlfmt/.yamlfmt.yaml".text = ''
      formatter:
        type: basic
        include_document_start: true
        retain_line_breaks_single: true
    '';
  };
}
