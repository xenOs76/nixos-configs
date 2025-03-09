{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      lint = {
        enable = true;
        lintersByFt = {
          dockerfile = ["hadolint"];
          json = ["jsonlint"];
          yaml = ["yamllint"];
          markdown = ["vale"];
          terraform = ["tflint"];
          text = ["vale"];
          sh = ["shellcheck"];
        };
      };
      treesitter = {
        enable = true;
        folding = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
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
          markdown
        ];
      };
      treesitter-textobjects.enable = true;
      treesitter-context.enable = true;
    };
  };
}
