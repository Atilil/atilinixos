_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim = {
      keymaps = [
        # Two independent toggleterm sessions
        {
          key = "<C-t>";
          mode = ["n" "t"];
          action = "<Cmd>1ToggleTerm<CR>";
          desc = "Toggle terminal (split)";
          silent = true;
        }
        {
          key = "<A-d>";
          mode = ["n" "t"];
          action = "<Cmd>2ToggleTerm direction=float<CR>";
          desc = "Toggle floating terminal";
          silent = true;
        }
        {
          key = "<Esc>";
          mode = ["t"];
          action = "<C-\\><C-n>";
          desc = "Toggle floating terminal";
          silent = true;
        }
        # Call smart-splits so navigation works between nvim, terminal and kitty panes
        {
          key = "<C-h>";
          mode = ["t"];
          action = ''function() require("smart-splits").move_cursor_left() end'';
          lua = true;
          desc = "Terminal: move to left window";
          silent = true;
        }
        {
          key = "<C-j>";
          mode = ["t"];
          action = ''function() require("smart-splits").move_cursor_down() end'';
          lua = true;
          desc = "Terminal: move to window below";
          silent = true;
        }
        {
          key = "<C-k>";
          mode = ["t"];
          action = ''function() require("smart-splits").move_cursor_up() end'';
          lua = true;
          desc = "Terminal: move to window above";
          silent = true;
        }
        {
          key = "<C-l>";
          mode = ["t"];
          action = ''function() require("smart-splits").move_cursor_right() end'';
          lua = true;
          desc = "Terminal: move to right window";
          silent = true;
        }
        {
          key = "<C-w>";
          mode = ["t"];
          action = "<C-\\><C-n><C-w>";
          desc = "Terminal: window command prefix";
          silent = true;
        }
      ];
      terminal.toggleterm = {
        enable = true;
        # null disables nvf's default <C-t>, which closed ANY open terminal
        mappings.open = null;
        lazygit = {
          enable = true;
          direction = "float";
        };
        setupOpts = {
          shade_terminals = true;
          shading_factor = -30;
          shading_ratio = -3;
          start_in_insert = true;
        };
      };
    };
  };
}
