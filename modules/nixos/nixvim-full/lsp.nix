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
        golangci_lint_ls.enable = true;
        helm_ls = {
          enable = true;
          filetypes = [
            "helm"
            "helmfile"
          ];
          rootMarkers = ["Chart.yaml"];
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
        yamlls = {
          enable = true;
          filetypes = [
            "yaml"
          ];
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
