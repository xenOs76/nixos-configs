{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    # extraConfigLua = ''
    #   _G.format_with_conform = function()
    #     local conform = require("conform")
    #     conform.format({
    #       timeout_ms = 3000,
    #       lsp_fallback = true,
    #     })
    #   end
    # '';

    plugins.conform-nvim.enable = true;
    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        lua = ["stylua"];
        nix = ["alejandra"];
        python = [
          "isort"
          "black"
        ];
        sh = ["shfmt"];
        json = ["fixjson"];
        yaml = ["yamlfmt"];
        markdown = [
          "markdownlint-cli2"
        ];
        nginx = ["nginxfmt"];
        go = [
          "goimports"
          "gofumpt"
        ];
      };

      formatters = with pkgs; {
        goimports = {
          command = "${pkgs.gotools}/bin/goimports";
          #command = "goimports";
          # command = "${lib.getExe' pkgs.gotools "goimports"}";
        };
        gofumpt = {
          command = "${lib.getExe gofumpt}";
        };
        black = {
          command = "${lib.getExe black}";
        };
        markdownlint-cli2 = {
          command = "${lib.getExe markdownlint-cli2}";
        };
        isort = {
          command = "${lib.getExe isort}";
        };
        alejandra = {
          command = "${lib.getExe alejandra}";
        };
        jq = {
          command = "${lib.getExe jq}";
        };
        fixjson = {
          command = "${lib.getExe fixjson}";
        };
        prettierd = {
          command = "${lib.getExe prettierd}";
        };
        stylua = {
          command = "${lib.getExe stylua}";
        };
        shellcheck = {
          command = "${lib.getExe shellcheck}";
        };
        shfmt = {
          command = "${lib.getExe shfmt}";
        };
        yamlfmt = {
          command = "${lib.getExe yamlfmt}";
        };
        nginxfmt = {
          command = "${lib.getExe nginx-config-formatter}";
        };
      };

      format_on_save =
        # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            return { timeout_ms = 200, lsp_fallback = true }
           end
        '';

      log_level = "warn";
      notify_on_error = true;
      notify_no_formatters = true;
    };
  };
}
