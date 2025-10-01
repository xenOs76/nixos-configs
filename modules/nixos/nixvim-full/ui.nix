{
  programs.nixvim = {
    plugins = {
      bufferline.enable = true;
      lualine.enable = true;
      web-devicons.enable = true;
      snacks.enable = true;
      notify.enable = true;
      noice.enable = true;
      vim-surround.enable = false;

      mini = {
        enable = true;
        modules = {
          # https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-surround.md
          surround = {
            mappings = {
              add = "sa";
              delete = "sd";
              find = "sf";
              find_left = "sF";
              highlight = "sh";
              replace = "sr";
              update_n_lines = "sn";
            };
          };
        };
      };

      tiny-inline-diagnostic = {
        enable = true;
        settings = {
          options = {
            multilines = {
              enabled = true;
              always_show = true;
            };
            show_source = {
              enabled = true;
              if_many = true;
            };
            set_arrow_to_diag_color = true;
            use_icons_from_diagnostic = false;
          };
          preset = "powerline";
          virt_texts = {
            priority = 2048;
          };
        };
      };
    };
  };
}
