{
  programs.nixvim = {
    plugins = {
      copilot-vim.enable = true;
      copilot-chat.enable = true;

      barbar.enable = true;
      indent-blankline.enable = true;
      illuminate.enable = true;
      lastplace.enable = true;
      autoclose.enable = true;
      which-key.enable = true;
      toggleterm.enable = true;
      todo-comments.enable = true;
      fzf-lua.enable = true;
      lazy.enable = true;

      # https://cmp.saghen.dev/
      blink-cmp = {
        enable = true;
        settings = {
          appearance = {
            nerd_font_variant = "normal";
            use_nvim_cmp_as_default = true;
          };

          completion = {
            accept = {
              auto_brackets = {
                enabled = true;
                semantic_token_resolution = {
                  enabled = false;
                };
              };
            };
            documentation = {
              auto_show = true;
            };
          };

          keymap = {
            "<CR>" = [
              "select_and_accept"
              "fallback"
            ];
            "<C-b>" = [
              "scroll_documentation_up"
              "fallback"
            ];
            "<C-e>" = [
              "hide"
            ];
            "<C-f>" = [
              "scroll_documentation_down"
              "fallback"
            ];
            "<C-n>" = [
              "select_next"
              "fallback"
            ];
            "<C-p>" = [
              "select_prev"
              "fallback"
            ];
            "<C-space>" = [
              "show"
              "show_documentation"
              "hide_documentation"
            ];
            "<C-y>" = [
              "select_and_accept"
            ];
            "<Down>" = [
              "select_next"
              "fallback"
            ];
            "<S-Tab>" = [
              "select_prev"
              "snippet_backward"
              "fallback"
            ];
            "<Tab>" = [
              "select_next"
              "snippet_forward"
              "fallback"
            ];
            "<Up>" = [
              "select_prev"
              "fallback"
            ];
            "<C-k>" = [
              "show_signature"
              "hide_signature"
              "fallback"
            ];
          };

          signature = {
            enabled = true;
          };

          sources = {
            default = [
              "lsp"
              "path"
              "buffer"
              "copilot"
              # "snippets"
              "ripgrep"
              "dictionary"
              "git"
              "spell"
            ];
            cmdline = [];
            providers = {
              buffer = {
                score_offset = -7;
              };

              lsp = {
                fallbacks = [];
              };

              spell = {
                module = "blink-cmp-spell";
                name = "Spell";
                score_offset = 100;
                opts = {
                };
              };

              # snippets = {
              #   presets = [
              #     "mini-snippets"
              #   ];
              #   opts = {
              #     friendly-snippets = true;
              #   };
              # };
              #
              ripgrep = {
                async = true;
                module = "blink-ripgrep";
                name = "Ripgrep";
                score_offset = 100;
                opts = {
                  prefix_min_len = 3;
                  context_size = 5;
                  max_filesize = "1M";
                  project_root_marker = ".git";
                  project_root_fallback = true;
                  search_casing = "--ignore-case";
                  additional_rg_options = {};
                  fallback_to_regex_highlighting = true;
                  ignore_paths = {};
                  additional_paths = {};
                  debug = false;
                };
              };

              copilot = {
                async = true;
                module = "blink-copilot";
                name = "copilot";
                score_offset = 100;
                # Optional configurations
                opts = {
                  max_completions = 3;
                  max_attempts = 4;
                  kind = "Copilot";
                  debounce = 750;
                  auto_refresh = {
                    backward = true;
                    forward = true;
                  };
                };
              };

              git = {
                module = "blink-cmp-git";
                name = "git";
                score_offset = 100;
                opts = {
                  commit = {};
                  git_centers = {
                    git_hub = {};
                  };
                };
              };

              dictionary = {
                module = "blink-cmp-dictionary";
                name = "Dict";
                score_offset = 100;
                min_keyword_length = 3;
                # Optional configurations
                opts = {
                };
              };
            };
          };
        };
      };

      blink-cmp-git.enable = true;
      blink-copilot.enable = true;
      blink-cmp-dictionary.enable = true;
      blink-cmp-spell.enable = true;
      blink-ripgrep.enable = true;
      blink-compat.enable = true;

      friendly-snippets.package = true;

      neo-tree = {
        enable = true;
        enableGitStatus = true;
      };

      telescope = {
        enable = false;
        settings = {
          defaults = {
            file_ignore_patterns = [
              "^.git/"
              "^.mypy_cache/"
              "^__pycache__/"
              "^output/"
              "^data/"
              "%.ipynb"
            ];
            layout_config = {
              prompt_position = "top";
            };
            mappings = {
              i = {
                "<A-j>" = {
                  __raw = "require('telescope.actions').move_selection_next";
                };
                "<A-k>" = {
                  __raw = "require('telescope.actions').move_selection_previous";
                };
              };
            };
            selection_caret = "> ";
            set_env = {
              COLORTERM = "truecolor";
            };
            sorting_strategy = "ascending";
          };
        };
      };

      startify = {
        enable = true;
        settings = {
          change_to_dir = false;
          custom_header = [
            ""
            "     ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
            "     ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
            "     ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
            "     ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
            "     ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "     ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ];
          fortune_use_unicode = true;
        };
      };
    };
  };
}
