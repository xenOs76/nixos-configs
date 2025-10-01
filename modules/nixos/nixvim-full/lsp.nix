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
      json.enable = false;
      yaml = {
        enable = true;
      };
    };

    # plugins.lspconfig.enable = true;
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

        gopls.enable = true;

        # https://www.lazyvim.org/extras/lang/go#nvim-lspconfig
        gopls.settings = {
          gopls = {
            gofumpt = true;
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
              nilness = true;
              unusedparams = true;
              unusedwrite = true;
              useany = true;
            };
            usePlaceholders = true;
            completeUnimported = true;
            staticcheck = true;
            directoryFilters = [
              "-.git"
              "-.vscode"
              "-.idea"
              "-.vscode-test"
              "-node_modules"
            ];
            semanticTokens = true;
          };
        };

        golangci_lint_ls.enable = true;

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
