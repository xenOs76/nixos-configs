{pkgs, ...}: {
  programs.nixvim = {
    plugins.lsp = {
      enable = true;

      servers = {
        ansiblels.enable = true;
        bashls.enable = true;
        docker_compose_language_service.enable = true;
        dockerls.enable = true;
        gopls.enable = true;
        helm_ls.enable = true;
        jinja_lsp.enable = false;
        nginx_language_server.enable = true;
        nixd.enable = true;
        pylsp.enable = true;
        ruff.enable = true;
        sqlls = {
          enable = true;
          package = pkgs.sqls;
        };
        yamlls.enable = true;
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
