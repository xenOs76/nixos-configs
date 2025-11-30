{pkgsUnstable, ...}: {
  home.file = {
    # https://github.com/sahaj-b/ghostty-cursor-shaders
    ".config/ghostty/ripple_cursor.glsl".text = builtins.readFile (
      builtins.fetchurl {
        url = "https://raw.githubusercontent.com/sahaj-b/ghostty-cursor-shaders/refs/heads/main/ripple_cursor.glsl";
        sha256 = "sha256:115qv32dw5ppxnzgw5vq1sx2vhhcfjw5h77k1k3hgp42czcnc221";
      }
    );
  };

  programs.ghostty = {
    enable = true;
    package = pkgsUnstable.ghostty;
    enableBashIntegration = true;
    installVimSyntax = true;
    settings = {
      font-size = 15;

      # shell-integration-features = "ssh-terminfo";  # WARN: breaks Ncurses on Ubuntu old LTS
      shell-integration-features = "ssh-env,no-cursor,sudo";
      maximize = "true";

      # theme = "TokyoNight Storm";
      theme = "Catppuccin Frappe";

      # custom-shader = ["ripple_cursor.glsl"]; # WARN: cpu intensive
      cursor-style = "block";
      cursor-style-blink = false;

      keybind = [
        "alt+g>r=reload_config"
        "alt+g>t=new_tab"
        "alt+g>e=open_config"

        "page_up=scroll_page_up"
        "page_down=scroll_page_down"
        "shift+page_up=adjust_selection:page_up"
        "shift+page_down=adjust_selection:page_down"

        # Tabs
        "ctrl+t=new_tab"

        # pane creation
        "super+l=new_split:right"
        "super+h=new_split:left"
        "super+j=new_split:down"
        "super+k=new_split:up"

        ## pane creation: wezterm compat
        "shift+alt+ctrl+5=new_split:right"
        "ctrl+alt+shift+\"=new_split:down"

        # pane navigation
        "alt+l=goto_split:right"
        "alt+h=goto_split:left"
        "alt+j=goto_split:down"
        "alt+k=goto_split:up"
      ];
    };
  };
}
