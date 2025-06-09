{
  programs.nixvim = {
    plugins = {
      bufferline.enable = true;
      lualine.enable = true;
      web-devicons.enable = true;
      snacks.enable = true;
      notify.enable = true;
      noice.enable = true;
      mini.enable = false;
      vim-surround.enable = true;
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
