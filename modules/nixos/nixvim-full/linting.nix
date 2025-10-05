{
  pkgs,
  pkgsUnstable,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vale
    hadolint
    yamllint
    tflint
    shellcheck
    pkgsUnstable.golangci-lint
    nodePackages.jsonlint
  ];

  programs.nixvim = {
    plugins = {
      #
      # https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
      #
      lint = {
        enable = true;
        lintersByFt = {
          dockerfile = ["hadolint"];
          json = ["jsonlint"];
          yaml = ["yamllint"];
          terraform = ["tflint"];
          sh = ["shellcheck"];
          go = ["golangcilint"];
        };
      };

      treesitter = {
        enable = true;
        folding = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          vim
          regex
          lua
          markdown
          markdown_inline
          bash
          json
          lua
          make
          markdown
          nix
          toml
          vimdoc
          xml
          yaml
          helm
          hcl
          dockerfile
          go
          gpg
          jq
          muttrc
          nginx
          pem
          promql
          ssh_config
          yaml
          xml
          sql
          hcl
          toml
          make
          python
        ];
        settings = {
          auto_install = false;
          # ensure_installed = "all";
          highlight = {
            additional_vim_regex_highlighting = true;
            custom_captures = {};
            disable = [
              "rust"
            ];
            enable = true;
          };
          ignore_install = [
            "rust"
          ];
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = false;
              node_decremental = "grm";
              node_incremental = "grn";
              scope_incremental = "grc";
            };
          };
          indent = {
            enable = true;
          };
          parser_install_dir = {
            __raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'treesitter')";
          };
          sync_install = false;
        };
      };
      treesitter-textobjects.enable = true;
      treesitter-context.enable = true;
    };
  };
}
