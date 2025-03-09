{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    clipboard.register = "unnamedplus";

    colorscheme = "dracula";

    colorschemes.ayu.enable = true;
    colorschemes.catppuccin.enable = false;
    colorschemes.dracula.enable = true;
    colorschemes.nord.enable = true;
    colorschemes.tokyonight.enable = true;
    colorschemes.vscode.enable = true;

    plugins.cmp.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-cmdline.enable = true;
    plugins.cmp-dictionary.enable = true;
    plugins.cmp-git.enable = true;
    plugins.cmp-path.enable = true;

    plugins.luasnip.package = true;

    #    plugins.barbar.enable = true;
    #    plugins.direnv.enable = true;
    #    plugins.gitignore.enable = true;
    plugins.indent-blankline.enable = true;
    plugins.illuminate.enable = true;
    plugins.lastplace.enable = true;
    plugins.lualine.enable = true;
    plugins.autoclose.enable = true;
    plugins.comment.enable = true;
    plugins.fugitive.enable = true;
    plugins.gitsigns.enable = true;
    plugins.lazy.enable = true;
    plugins.lazygit.enable = true;
    plugins.mini.enable = true;
    plugins.nvim-tree.enable = true;
    plugins.nix.enable = true;

    plugins.lint.enable = true;
    # plugins.lint.lintersByFt = {
    #   json = [
    #     "jsonlint"
    #   ];
    #   markdown = [
    #     "vale"
    #   ];
    #   terraform = [
    #     "tflint"
    #   ];
    #   text = [
    #     "vale"
    #   ];
    # };

    plugins.lsp.enable = true;
    plugins.lsp.servers.nixd.enable = true;
    plugins.lsp.servers.bashls.enable = true;
    #    plugins.lsp.servers.ruff.enable = true;
    #    plugins.lsp.servers.yamlls.enable = true;

    #    plugins.lsp.servers.ansiblels.enable = false;
    #    plugins.lsp.servers.docker_compose_language_service.enable = false;
    #    plugins.lsp.servers.dockerls.enable = false;
    #    plugins.lsp.servers.gopls.enable = false;
    #    plugins.lsp.servers.helm_ls.enable = false;
    #    plugins.lsp.servers.terraformls.enable = false;
    # plugins.lsp.servers.tflint.enable = false;
    plugins.lsp-format.enable = true;

    plugins.conform-nvim.enable = true;
    plugins.conform-nvim.settings.formatters_by_ft = {
      # json = ["jq"];
      lua = ["stylua"];
      nix = ["alejandra"];
      #      python = ["isort" "black"];
      sh = ["shfmt" "shellcheck"];
    };

    plugins.conform-nvim.settings.formatters = {
      #     black = {command = "${lib.getExe pkgs.black}";};
      #     isort = {command = "${lib.getExe pkgs.isort}";};
      alejandra = {command = "${lib.getExe pkgs.alejandra}";};
      jq = {command = "${lib.getExe pkgs.jq}";};
      #prettierd = {command = "${lib.getExe pkgs.prettierd}";};
      stylua = {command = "${lib.getExe pkgs.stylua}";};
      shellcheck = {command = "${lib.getExe pkgs.shellcheck}";};
      shfmt = {command = "${lib.getExe pkgs.shfmt}";};
    };

    plugins.treesitter = {
      enable = true;
      folding = false;
      # auto_install = false;
      # ensure_installed = [
      #   "git_config"
      #   "git_rebase"
      #   "gitattributes"
      #   "gitcommit"
      #   "gitignore"
      # ];
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        json
        lua
        make
        markdown
        nix
        regex
        toml
        vim
        vimdoc
        xml
        yaml
        helm
        hcl
        dockerfile
        go
        gpg
        jq
        muttrc
        # nginx
        pem
        promql
        ssh_config
        yaml
        xml
      ];
    };

    plugins.notify.enable = true;
    #    plugins.rainbow-delimiters.enable = true;
    plugins.smart-splits.enable = true;
    plugins.todo-comments.enable = true;
    plugins.telescope.enable = true;
    plugins.telescope.settings = {
      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        layout_config = {prompt_position = "top";};
        mappings = {
          i = {
            "<A-j>" = {
              __raw = "require('telescope.actions').move_selection_next";
            };
            "<A-k>" = {
              __raw = "require('telescope.actions').move_selection_previous";
            };
          };
        };
        selection_caret = "> ";
        set_env = {COLORTERM = "truecolor";};
        sorting_strategy = "ascending";
      };
    };
    plugins.toggleterm.enable = true;
    plugins.web-devicons.enable = true;
    plugins.which-key.enable = true;
  };
}
