{
  programs.nixvim = {
    plugins = {
      bufferline.enable = true;
      lualine = {
        enable = true;
      };
      web-devicons = {
        enable = true;
        # customIcons = {
        #   override_by_extension = {
        #     "go" = {
        #       icon = " ";
        #       color = "#81e043";
        #       name = "Go file";
        #     };
        #   };
        # };
      };
      snacks.enable = true;
      notify.enable = false;

      # https://github.com/folke/noice.nvim
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

      # From 25.11
      # mini-icons.enable = true; # disable web-devicons
      # mini-animate = {
      #   enable = true;
      #   settings = {
      #     close = {
      #       enable = true;
      #     };
      #     cursor = {
      #       enable = true;
      #     };
      #     open = {
      #       enable = true;
      #     };
      #     resize = {
      #       enable = true;
      #     };
      #     scroll = {
      #       enable = true;
      #     };
      #   };
      # };

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
