{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    rich-cli
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    package = pkgs.yazi;
    plugins = {
      "bypass" = pkgs.yaziPlugins.bypass;
      "chmod" = pkgs.yaziPlugins.chmod;
      "full-border" = pkgs.yaziPlugins.full-border;
      "lazygit" = pkgs.yaziPlugins.lazygit;
      "mediainfo" = pkgs.yaziPlugins.mediainfo;
      "no-status" = pkgs.yaziPlugins.no-status;
      "ouch" = pkgs.yaziPlugins.ouch;
      "restore" = pkgs.yaziPlugins.restore;
      "rich" = pkgs.yaziPlugins.rich-preview;
      "smart-enter" = pkgs.yaziPlugins.smart-enter;
      "toggle-pane" = pkgs.yaziPlugins.toggle-pane;
    };

    settings = {
      log = {
        enabled = false;
      };
      mgr = {
        show_hidden = false;
        sort_by = "mtime";
        sort_dir_first = true;
        sort_reverse = true;
        linemode = "mtime";
      };

      keymap = {
        # WARN the keymap defined here seems not to work
        # as it ends yazi.toml instead of keymap.toml
        # see the following keymap.toml file for a
        # workaround
        mgr.prepend_keymap = [
          {
            run = "shell \"$SHELL\" --block";
            for = "unix";
            desc = "Open $SHELL here";
            on = ["!"];
          }
          {
            run = "quit";
            on = ["q"];
          }
        ];
      };
    };
  };

  home.file."${config.home.homeDirectory}/.config/yazi/keymap.toml".text = ''
    [[mgr.prepend_keymap]]
    on   = "!"
    for  = "unix"
    run  = 'shell "$SHELL" --block'
    desc = "Open $SHELL here"
  '';

  programs.bash.shellAliases = {
    yz = "yazi";
  };
}
