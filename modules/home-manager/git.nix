{pkgs, ...}: {
  home.packages = with pkgs; [
    pre-commit
    pre-commit-hook-ensure-sops
    gitleaks
    git-secrets
    gh
    commitizen
  ];

  programs.git = {
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
    };
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
    };
    ignores = [
      "*~"
      "*.swp"
    ];
  };

  catppuccin.delta.enable = true;
  programs.git.delta = {
    enable = true;
    options = {
      side-by-side = true;
      whitespace-error-style = "22 reverse";
    };
  };

  catppuccin.lazygit.enable = true;
  programs.lazygit = {
    enable = true;
    settings = {
      # https://github.com/jesseduffield/lazygit/wiki/Custom-Commands-Compendium
      customCommands = [
        {
          key = "C";
          command = "git cz c";
          description = "Commit with commitizen";
          context = "files";
          loadingText = "Opening commitizen...";
          # subprocess = true;
          output = "terminal";
        }
      ];
    };
  };
}
