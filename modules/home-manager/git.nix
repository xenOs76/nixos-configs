{pkgs, ...}: {
  home.packages = with pkgs; [
    pre-commit
    pre-commit-hook-ensure-sops
    gitleaks
    git-secrets
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

  programs.git.delta = {
    enable = true;
    options = {
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-decoration-style = "none";
        file-style = "bold yellow ul";
        side-by-side = "true";
        syntax-theme = "Catppuccin Frappe";
      };
      features = "decorations";
      whitespace-error-style = "22 reverse";
    };
  };
}
