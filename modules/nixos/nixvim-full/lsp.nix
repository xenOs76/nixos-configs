{pkgs, ...}: {
  programs.nixvim = {
    autoCmd = [
      # https://nix-community.github.io/nixvim/25.05/plugins/helm.html#helm
      {
        event = "FileType";
        pattern = "helm";
        command = "LspRestart";
      }
    ];

    plugins.helm = {
      enable = true;
    };

    plugins.schemastore = {
      enable = true;
      json = {
        enable = true;
      };
      yaml = {
        enable = true;
        settings = {
          extra = [
            {
              description = "HTTPS-Wrench JSON schema";
              fileMatch = "https-wrench*.yaml";
              name = "https-wrench.schema.json";
              url = "https://raw.githubusercontent.com/xenOs76/https-wrench/refs/heads/main/https-wrench.schema.json";
            }
          ];
        };
      };
    };

    plugins.trouble = {
      enable = true;
    };

    plugins.lsp = {
      enable = true;

      # https://www.lazyvim.org/plugins/lsp#nvim-lspconfig
      # https://github.com/nix-community/nixvim/blob/main/plugins/lsp/default.nix
      inlayHints = true;

      servers = {
        ansiblels.enable = true;
        bashls.enable = true;
        docker_compose_language_service.enable = true;
        dockerls.enable = true;
        jsonls.enable = true;

        gopls.enable = true;
        # https://www.lazyvim.org/extras/lang/go#nvim-lspconfig
        gopls.settings = {
          gopls = {
            codelenses = {
              gc_details = false;
              generate = true;
              regenerate_cgo = true;
              run_govulncheck = true;
              test = true;
              tidy = true;
              upgrade_dependency = true;
              vendor = true;
            };

            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = true;
              compositeLiteralTypes = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };

            analyses = {
              assign = true;
              bools = true;
              composites = true;
              erroras = true;
              httpresponse = true;
              ifaceassert = true;
              loopclosure = true;
              lostcancel = true;
              nilfunc = true;
              nilness = true;
              printf = true;
              shadow = true;
              simplifycomposites = true;
              simplifyrange = true;
              simplifyslice = true;
              stdmethods = true;
              stringintconv = true;
              structtag = true;
              unmarshal = true;
              unreachable = true;
              unusedparams = true;
              unusedvariable = true;
              unusedwrite = true;
              useany = true;
            };

            gofumpt = true;
            matcher = "Fuzzy";
            semanticTokens = true;
            staticcheck = true;
            usePlaceholders = true;
            completeUnimported = true;
            completionDocumentation = true;

            directoryFilters = [
              "-.git"
              "-.vscode"
              "-.idea"
              "-.vscode-test"
              "-node_modules"
            ];
          };
        };

        # https://github.com/nametake/golangci-lint-langserver?tab=readme-ov-file#configuration-for-nvim-lspconfig
        golangci_lint_ls = {
          enable = true;
          rootMarkers = [
            "go.mod"
            ".git"
            ".go"
          ];
          settings = {
            cmd = [
              "${pkgs.golangci-lint-langserver}/bin/golangci-lint-langserver"
            ];
            root_dir = "lspconfig.util.root_pattern('.git', 'go.mod', '.go')";
            init_options = {
              command = [
                "${pkgs.golangci-lint}/bin/golangci-lint"
                "run"
                "--output.json.path"
                "stdout"
                "--show-stats=false"
                "--issues-exit-code=1"
              ];
            };
          };
        };

        helm_ls = {
          enable = true;
          settings = {
            filetypes = [
              "helm"
              "helmfile"
            ];

            rootMarkers = ["Chart.yaml"];

            valuesFiles = {
              mainValuesFile = "values.yaml";
              lintOverlayValuesFile = "values.lint.yaml";
              additionalValuesFilesGlobPattern = "values*.yaml";
            };

            helmLint = {
              enabled = true;
              ignoredMessages = {};
            };

            yamlls = {
              enabled = true;
              path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
              enabledForFilesGlob = "*.{yaml,yml}";
              diagnosticsLimit = 50;
              showDiagnosticsDirectly = false;
              config = {
                schemas = {
                  kubernetes = "templates/**";
                };
                completion = true;
                hover = true;
              };
            };
          };
        };

        yamlls = {
          enable = true;
          filetypes = [
            "yaml"
          ];
        };

        jinja_lsp.enable = false;
        nginx_language_server.enable = true;
        nixd.enable = true;
        pylsp.enable = true;
        ruff.enable = true;
        sqlls = {
          enable = true;
          package = pkgs.sqls;
        };
        terraformls.enable = true;
        tflint.enable = false;
      };
    };

    plugins.lsp-format = {
      enable = true;
      settings = {
        yaml = {
          tab_width = 2;
        };
      };
    };
  };
}
