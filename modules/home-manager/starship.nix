{pkgs, ...}: {
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      format = pkgs.lib.concatStrings [
        "[   ](#4995fd bold)"
        "$nix_shell"
        #"${custom.vpnstatus}"
        #"${custom.dotfilesStatus}"
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$fill"
        "$aws"
        "$kubernetes"
        "$python"
        "$golang"
        #"${custom.tfver}"
        "$line_break"
        "$jobs"
        "$character"
      ];

      add_newline = false;
      line_break.disabled = false;
      gcloud.disabled = true;
      scan_timeout = 10;

      nix_shell = {
        disabled = false;
        impure_msg = "[impure](italic red)";
        pure_msg = "[pure](italic green)";
        unknown_msg = "unknown(italic yellow)";
        format = " [  ](blue)$state [$name](bold italic blue)";
      };

      username = {
        format = " [$user ]($style)";
        show_always = false;
        style_root = "fg:#ed4466 bold";
        style_user = "fg:#99b3ff ";
        disabled = false;
      };

      hostname = {
        ssh_only = false;
        format = "[|](fg:#769ff0)[$hostname](fg:#769ff0 bg:#394260)[|](fg:#769ff0) ";
        style = "fg:#769ff0 bg:#394260";
        disabled = false;
      };

      directory = {
        format = "[$path]($style)[$read_only]($read_only_style) ";
        truncation_symbol = "  ";
        truncation_length = 3;
        truncate_to_repo = true;
        repo_root_style = "green";
        style = "fg:#a3bae6 ";
        read_only = "󰌾";
      };

      git_branch = {
        symbol = "  ";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        style = "fg:#00b33c";
      };

      git_commit = {
        commit_hash_length = 6;
        format = "[\($hash$tag\)]($style) ";
        tag_symbol = " 󰓹 ";
        tag_disabled = false;
      };

      git_status = {
        disabled = false;
        #format = "([[$conflicted](#cfb963)[$stashed](#7785bb)[$deleted](#cf6379)$renamed[$modified](#b1bce7)$staged[$untracked](#96d7ff)[$ahead_behind](#96acff)]($style) )";
        format = "([$conflicted$stashed$deleted$renamed$modified$staged$untracked[$ahead_behind](#96acff)]($style) )";
        style = "#66ccff";

        ### all_status = "$conflicted$stashed$deleted$renamed$modified$staged$untracked
        conflicted = "[=\${count}](#cfb963)";
        stashed = "[*\${count}](#7785bb)";
        deleted = "[✘\${count}](#cf6379)";
        renamed = "»\${count}";
        modified = "[!\${count}](#b1bce7)";
        staged = "+\${count}";
        untracked = "[?\${count}](#96d7ff)";

        ahead = "\${count}";
        diverged = " \${ahead_count}\${behind_count}";
        behind = "\${count}";
      };

      aws = {
        disabled = false;
        style = "#ff6600";
        format = " [$symbol $profile]($style)[{$region}](fg:#ff7d00 bold) ";
        symbol = "󰅠";
        region_aliases = {
          eu-central-1 = "DE";
          eu-west-1 = "IE";
          us-east-1 = "US-E1";
        };
        profile_aliases = {
          dev-SiteReliabilityEngineer = "dev[SRE]";
          staging-SiteReliabilityEngineer = "staging[SRE]";
          onboarding-SiteReliabilityEngineer = "onboarding[SRE]";
          production-SiteReliabilityEngineer = "production[SRE]";
        };
      };

      kubernetes = {
        format = "[$symbol$context](fg:blue)[{$namespace}](fg:green bold)";
        style = "fg:#66b3ff";
        symbol = "󱃾 ";
        disabled = false;
        contexts = [
          {
            context_pattern = "arn:aws:eks:[\\w\\d-]+:\\d+:cluster/(.*)";
            context_alias = "$1";
          }
        ];
      };

      python = {
        disabled = false;
        symbol = "  ";
        style = "yellow";
        format = "[$symbol{$virtualenv}]($style)";
        pyenv_version_name = true;
        detect_extensions = ["py"];
        python_binary = [
          "python"
          "python3"
          "python2"
        ];
      };

      golang = {
        symbol = "  ";
        format = "[$symbol$version ]($style)";
      };

      fill = {
        symbol = "_";
        style = "green";
      };
    };
  };
}
