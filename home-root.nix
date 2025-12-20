{pkgs, ...}: {
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    httpie
    eza
  ];
  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    enableCompletion = true;

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      #STARSHIP_CONFIG = "/etc/starship-root.toml";
      FZF_DEFAULT_COMMAND = "fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build} --type f";
      FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'";
      ANSIBLE_NOCOWS = "1";
      BAT_THEME = "ansi";
      FLAKE_ENV = "true";
    };

    initExtra = ''
      #. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      alias nokube='kubectx -u'
      alias whatismyip='curl -4 ipinfo.io/ip'
      alias whatismyipv6='curl -6 https://ipv6.icanhazip.com'
    '';

    shellAliases = {
      ".." = "cd ..";
      cat = "bat -pp";
      man = "batman";
      cd = "z";
      config = ''git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'';
      ls = "eza";
      ll = "eza -lghaa --git --git-repos";
      lltree = "eza -lgha --git --git-repos -T --total-size --git-ignore";
      llsize = "ll --sort=size --reverse  --total-size";
      lltime = "ll --sort=time --reverse";
      gst = "git status";
    };
  };
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.starship.enable = true;

  home.file = {
    # https://starship.rs/presets/pure-preset#pure-preset
    ".config/starship.toml".text = ''

      format = """
      $username\
      $hostname\
      $directory\
      $git_branch\
      $git_state\
      $git_status\
      $cmd_duration\
      $line_break\
      $python\
      $character"""

      [directory]
      style = "bright-blue"

      [hostname]
      ssh_only = false
      ssh_symbol = " "
      trim_at = "."
      detect_env_vars = []
      format = "[{$ssh_symbol$hostname}]($style) "
      style = "fg:#769ff0 bg:#394260"
      disabled = false

      [character]
      success_symbol = "[>](green)"
      error_symbol = "[>](red)"
      vimcmd_symbol = "[<](purple)"

      [git_branch]
      format = "[$branch]($style)"
      style = "green"

      [git_status]
      format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)"
      style = "cyan"
      conflicted = "​"
      untracked = "​"
      modified = "​"
      staged = "​"
      renamed = "​"
      deleted = "​"
      stashed = "≡"

      [git_state]
      format = '\([$state( $progress_current/$progress_total)]($style)\) '
      style = "green"

      [cmd_duration]
      format = "[$duration]($style) "
      style = "yellow"

      [python]
      format = "[$virtualenv]($style) "
      style = "yellow"

    '';
  };
}
