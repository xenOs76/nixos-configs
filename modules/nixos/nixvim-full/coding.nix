{
  programs.nixvim = {
    plugins = {
      comment.enable = true;
      direnv.enable = true;
      nix.enable = true;

      fugitive.enable = true;
      gitsigns.enable = true;
      gitignore.enable = true;
      lazygit.enable = true;
    };
  };
}
