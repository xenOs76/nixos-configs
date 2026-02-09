{
  programs.wezterm = {
    enable = true;
    colorSchemes = {};
    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()
      local hostname = wezterm.hostname()
      local font_size_by_host
      local font_fallback_by_host
      local mux = wezterm.mux
      local win_x = 330
      local win_y = 30
      local vim_pane_cwd = "git/gitea"

      -- local gui = wezterm.gui
      -- if gui then
      --   gui.enumerate_gpus()
      -- end
      --
      font_size_by_host = 15
      -- font_fallback_by_host = wezterm.font_with_fallback({ "Fira Code", "Symbols Nerd Font" })
      font_fallback_by_host = wezterm.font_with_fallback({ "JetBrains Mono", "Symbols Nerd Font" })
      -- font_fallback_by_host = wezterm.font_with_fallback({ "Hack", "Symbols Nerd Font" })
      -- font_fallback_by_host = wezterm.font_with_fallback({ "Noto Sans Mono", "Symbols Nerd Font" })
      init_rows = 55
      init_cols = 240

      wezterm.on("gui-startup", function(cmd)
      	-- https://wezfurlong.org/wezterm/config/lua/wezterm.mux/spawn_window.html?h=position#position
      	local first_tab, first_pane, window = mux.spawn_window(cmd or { position = { x = win_x, y = win_y } })
      	local second_tab, second_pane, _ = window:spawn_tab({ cwd = vim_pane_cwd })

      	first_tab:set_title("shell")
      	-- second_tab:set_title("vim")
      	-- second_pane:split({ direction = "Bottom", size = 0.30 })
      	-- second_pane:activate()
      	-- second_pane:send_text("vi\n")
      	-- first_pane:split({ direction = "Bottom", size = 0.30 })
      	-- first_pane:send_text("show-logo\n")
      	-- first_pane:send_text("zellij\n")
      	first_pane:activate()
      end)

      config.dpi = 192
      config.enable_wayland = false
      config.prefer_egl = false
      config.front_end = "WebGpu"
      config.webgpu_power_preference = "HighPerformance"
      -- config.color_scheme = "Dracula (Official)"
      -- config.color_scheme = "Catppuccin Mocha"
      -- config.color_scheme = "Catppuccin Macchiato"
      -- config.color_scheme = "Catppuccin Latte"
      config.color_scheme = "Catppuccin Frappe"
      -- config.color_scheme = "Tokyo Night"
      -- config.color_scheme = 'Catppuccin Frappé (Gogh)'
      -- config.color_scheme = 'Materia (base16)'

      config.audible_bell = "Disabled"
      config.window_background_opacity = 1
      config.window_decorations = "RESIZE"
      config.scrollback_lines = 50000
      config.font = font_fallback_by_host
      config.font_size = font_size_by_host
      -- config.dpi = 192.0

      config.hide_tab_bar_if_only_one_tab = false
      config.use_fancy_tab_bar = false
      config.adjust_window_size_when_changing_font_size = false

      -- initial rows and cols compatible with:
      -- wezterm start --position 350,0
      --
      config.initial_rows = init_rows
      config.initial_cols = init_cols
      config.warn_about_missing_glyphs = false

      return config
    '';
  };
}
