{
  programs.nixvim = {
    keymaps = [
      {
        key = "<leader>qq";
        mode = "n";
        action = "<cmd>qa<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Quit All";
        };
      }
      {
        key = "<leader>ww";
        mode = "n";
        action = "<cmd>write<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "[w]rite";
        };
      }

      {
        key = "<leader>ee";
        mode = "n";
        action = "<cmd>Neotree dir=./ toggle<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Explorer NeoTree (cwd)";
        };
      }
      {
        key = "<leader>eb";
        mode = "n";
        action = "<cmd>Neotree buffers toggle<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "NeoTree Buffer Explorer";
        };
      }
      {
        key = "<leader>eE";
        mode = "n";
        action = "<cmd>Neotree dir=/ toggle<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Explorer NeoTree (Root Dir)";
        };
      }
      {
        key = "<leader>ff";
        mode = "n";
        action = "<cmd>Fzf files<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "FzfLua files";
        };
      }
      {
        key = "<leader>fb";
        mode = "n";
        action = "<cmd>Fzf buffers<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "FzfLua buffers";
        };
      }
      {
        key = "<leader>gs";
        mode = "n";
        action = "<cmd>Git<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "[g]it [s]tatus";
        };
      }
      {
        key = "<leader>gb";
        mode = "n";
        action = "<cmd>Gitsigns blame<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Gitsigns blame";
        };
      }
      {
        key = "<leader>gl";
        mode = "n";
        action = "<cmd>LazyGit<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "LazyGit";
        };
      }
      # {
      #   key = "<leader>tg";
      #   mode = "n";
      #   action = "<cmd>Telescope live_grep<CR>";
      #   options = {
      #     silent = true;
      #     noremap = true;
      #     desc = "Telescope live_grep";
      #   };
      # }
      # {
      #   key = "<leader>tb";
      #   mode = "n";
      #   action = "<cmd>Telescope buffers<CR>";
      #   options = {
      #     silent = true;
      #     noremap = true;
      #     desc = "Telescope live_grep";
      #   };
      # }
      {
        key = "<leader>fg";
        mode = "n";
        action = "<cmd>FzfLua grep<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "FzfLua grep";
        };
      }
      {
        key = "<leader>tt";
        mode = "n";
        action = "<cmd>ToggleTerm<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "ToggleTerm";
        };
      }
      {
        key = "<leader>y";
        mode = [
          "n"
          "v"
        ];
        action = ''"+y'';
        options = {
          silent = true;
          noremap = true;
          desc = "[y]ank to system clipboard";
        };
      }
      {
        key = "<leader>Y";
        mode = "n";
        action = ''"+Y'';
        options = {
          silent = true;
          noremap = true;
          desc = "[Y]ank line to system clipboard";
        };
      }
      {
        key = "Q";
        mode = "n";
        action = "<nop>";
        options = {
          silent = true;
          noremap = true;
          desc = "Don't";
        };
      }
      {
        key = "<leader>mp";
        mode = [
          "n"
          "v"
        ];
        action = ":lua _G.format_with_conform()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "[m]ake [p]retty by formatting";
        };
      }
    ];
  };
}
