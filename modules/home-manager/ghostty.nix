{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      font-size = 14;

      # theme = "tokyonight-storm";
      theme = "catppuccin-frappe";

      keybind = [
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
