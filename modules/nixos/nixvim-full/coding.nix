{
  programs.nixvim = {
    plugins = {
      comment.enable = true;
      direnv.enable = true;
      nix.enable = true;
      fugitive.enable = false;
      gitsigns.enable = true;
      gitignore.enable = true;
      lazygit.enable = true;

      avante = {
        enable = true;
        settings = {
          diff = {
            autojump = true;
            debug = false;
            list_opener = "copen";
          };
          highlights = {
            diff = {
              current = "DiffText";
              incoming = "DiffAdd";
            };
          };
          hints = {
            enabled = true;
          };
          mappings = {
            diff = {
              both = "cb";
              next = "]x";
              none = "c0";
              ours = "co";
              prev = "[x";
              theirs = "ct";
            };
          };
          provider = "gemini";
          # -- auto_suggestions_provider = "copilot";
          behaviour = {
            auto_suggestions = true;
            auto_set_highlight_group = true;
            auto_set_keymaps = true;
            auto_apply_diff_after_generation = false;
            support_paste_from_clipboard = false;
          };
          providers = {
            gemini = {
              # -- @see https://ai.google.dev/gemini-api/docs/models/gemini
              # model = "gemini-3.0-pro";
              model = "gemini-2.5-flash";
              temperature = 0;
              max_tokens = 4096;
            };
          };
          windows = {
            sidebar_header = {
              align = "center";
              rounded = true;
            };
            width = 30;
            wrap = true;
          };
        };
      };
    };
  };
}
