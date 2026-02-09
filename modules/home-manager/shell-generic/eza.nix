{
  programs = {
    eza = {
      enable = true;
      enableBashIntegration = true;
      git = true;
      icons = "auto";
    };
    bash.shellAliases = {
      ls = "eza";
      ll = "eza -lhaa --git --git-repos --no-user --octal-permissions --no-permissions --icons --time-style='+%Y-%m-%d %H:%M'";
      llnewest = "eza --sort=time --reverse --oneline --git-ignore --changed --long --no-filesize --no-user --no-permissions --time-style=\"+%y-%m-%d %h:%m -\" --icons=auto";
      lldirnewest = "llnewest -D";
      lltree = "eza -lgha --git --git-repos -T --total-size";
      llsize = "ll --sort=size --reverse  --total-size";
      lltime = "ll --sort=time --reverse";
    };
  };
}
