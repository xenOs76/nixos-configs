{
  programs.nixvim = {
    plugins = {
      bufferline.enable = true;
      lualine.enable = true;
      web-devicons.enable = true;
      snacks = {
        enable = true;
      };
      mini.enable = true;
      notify.enable = true;
    };
  };
}
