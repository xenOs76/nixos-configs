{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    commitizen
    gh
    git-secrets
    git-worktree-switcher
    gitleaks
    glab
    pre-commit
    pre-commit-hook-ensure-sops
    prek
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = config.os76Cfg.gitUserName;
          email = config.os76Cfg.gitUserEmail;
        };
        init.defaultBranch = "main";
        alias = {
          ci = "commit";
          co = "checkout";
          s = "status";
          st = "status";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
        };
        push = {
          autoSetupRemote = true;
        };
      };
      ignores = [
        "*~"
        "*.swp"
      ];
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        side-by-side = true;
        whitespace-error-style = "22 reverse";
      };
    };

    lazygit = {
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

    bash = {
      shellAliases = {
        gdiff = "git diff";
        gst = "git status";
        lgit = "lazygit";

        glab-mr-delta = "glab mr diff --raw | delta";
        glab-mr-list = "glab mr list";
        glab-mr-view = "glab mr view";
        glab-pipeline-view = "glab pipeline view";
        glab-repo-list = "glab repo list --member";
        glab-repo-list-mine = "glab repo list --mine";

        gwt = "git worktree";
        gwt-add = "git worktree add";
        gwt-list = "git worktree list";
        gwt-remove = "git worktree remove";
      };
    };
  };
}
