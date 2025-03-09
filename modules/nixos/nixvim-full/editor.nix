{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      barbar.enable = true;
      indent-blankline.enable = true;
      illuminate.enable = true;
      lastplace.enable = true;
      autoclose.enable = true;
      which-key.enable = true;
      toggleterm.enable = true;
      todo-comments.enable = true;
      fzf-lua.enable = true;
      lazy.enable = true;

      cmp.enable = true;
      cmp = {
        autoEnableSources = true;
        settings = {
          completion = {completeopt = "menu,menuone,noinsert";};
          sources = [{name = "nvim_lsp";} {name = "path";} {name = "buffer";}];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          preselect = "cmp.PreselectMode.Item";
        };
      };

      cmp-buffer.enable = true;
      cmp-cmdline.enable = true;
      cmp-dictionary.enable = true;
      cmp-git.enable = true;
      cmp-path.enable = true;
      luasnip.package = true;

      neo-tree = {
        enable = true;
        enableGitStatus = true;
      };

      telescope = {
        enable = true;
        settings = {
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
      };

      startify = {
        enable = true;
        settings = {
          change_to_dir = false;
          custom_header = [
            ""
            "     ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
            "     ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
            "     ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
            "     ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
            "     ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "     ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ];
          fortune_use_unicode = true;
        };
      };
    };
  };
}
