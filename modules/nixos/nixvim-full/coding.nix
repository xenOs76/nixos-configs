{
  programs.nixvim = {
    plugins = {
      comment.enable = true;
      direnv.enable = true;
      nix.enable = true;
      fugitive.enable = false;
      gitsigns.enable = true;
      gitignore.enable = true;
      lazygit.enable = true;
    };
  };
}
