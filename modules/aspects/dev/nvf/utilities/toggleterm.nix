_: {
  den.aspects.nvf.homeManager = {lib, ...}: let
    inherit (lib.generators) mkLuaInline;
  in {
    programs.nvf.settings.vim = {
      autocmds = [
        {
          # Buffer-local so other :terminal buffers keep Esc and readline keys
          desc = "Toggleterm: terminal-mode keymaps";
          event = ["TermOpen"];
          pattern = ["term://*#toggleterm#*"];
          callback = mkLuaInline ''
            function(args)
              -- lazygit is a toggleterm terminal but needs Esc and C-h/j/k/l itself
              if vim.api.nvim_buf_get_name(args.buf):find("lazygit", 1, true) then return end
              local function map(lhs, rhs, desc)
                vim.keymap.set("t", lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
              end
              local function ss(fn) return function() require("smart-splits")[fn]() end end
              -- Double Esc so a single one reaches zsh vi-mode
              map("<Esc><Esc>", [[<C-\><C-n>]], "Terminal: leave terminal mode (double Esc)")
              -- smart-splits keeps navigation working between nvim, terminal and kitty panes
              map("<C-h>", ss("move_cursor_left"), "Terminal: move to left window")
              map("<C-j>", ss("move_cursor_down"), "Terminal: move to window below")
              map("<C-k>", ss("move_cursor_up"), "Terminal: move to window above")
              map("<C-l>", ss("move_cursor_right"), "Terminal: move to right window")
              map("<C-w>", [[<C-\><C-n><C-w>]], "Terminal: window command prefix")
            end
          '';
        }
      ];
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
