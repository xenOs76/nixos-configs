{
  programs.nixvim = {
    plugins = {
      bufferline.enable = true;
      lualine.enable = true;
      web-devicons.enable = true;
      snacks.enable = true;
      notify.enable = true;
      mini.enable = false;
      vim-surround.enable = true;
    };
  };
}
