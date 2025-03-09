{pkgs, ...}: {
  programs.nixvim = {
    plugins.conform-nvim.enable = true;
    plugins.conform-nvim.settings = {
      formatters_by_ft = {
        json = ["jq"];
        lua = ["stylua"];
        nix = ["alejandra"];
        python = ["isort" "black"];
        sh = ["shfmt" "shellcheck"];
        yaml = ["yamlfmt"];
        nginx = ["nginxfmt"];
      };

      formatters = with pkgs; {
        black = {command = "${lib.getExe black}";};
        isort = {command = "${lib.getExe isort}";};
        alejandra = {command = "${lib.getExe alejandra}";};
        jq = {command = "${lib.getExe jq}";};
        prettierd = {command = "${lib.getExe prettierd}";};
        # stylua = {command = "${lib.getExe stylua}";};
        shellcheck = {command = "${lib.getExe shellcheck}";};
        shfmt = {command = "${lib.getExe shfmt}";};
        yamlfmt = {command = "${lib.getExe yamlfmt}";};
        nginxfmt = {command = "${lib.getExe nginx-config-formatter}";};
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
