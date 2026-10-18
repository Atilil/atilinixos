_: {
  den.aspects.nvf.homeManager = {lib, ...}: let
    inherit (lib.generators) mkLuaInline;
  in {
    programs.nvf.settings.vim.binds.whichKey = {
      enable = true;

      setupOpts = {
        preset = "helix";
        delay = 500;
        win.width = {
          min = 30;
          max = 0.8;
        };
        layout.width.min = 999;
        plugins.presets.z = false;
        # Cluster entries by a `[Tag]` description prefix first, then fall back to
        # the built-in sorters.
        sort = [
          (mkLuaInline ''function(item) return (item.desc or ""):match("^%[(%w+)%]") or "~" end'')
          "local"
          "order"
          "group"
          "alphanum"
          "mod"
        ];

        spec = mkLuaInline ''
          {
            {
              mode = "x",
              { "gz", desc = "[Surround] Add around selection" },
              { "gZ", desc = "[Surround] Add around selection (new lines)" },
              { "gc", desc = "[Comment] Toggle" },
              { "gh", desc = "[Git] Apply hunk" },
              { "gH", desc = "[Git] Reset hunk" },
              { "gS", desc = "[Edit] Split/join arguments" },
              { "gx", desc = "[Open] URL/file under cursor" },
              { "gra", desc = "[LSP] Code action" },
              { "g%", desc = "[Match] Jump to match (backward)" },
              { "[h", desc = "[Git] Previous hunk" },
              { "]h", desc = "[Git] Next hunk" },
              { "[H", desc = "[Git] First hunk" },
              { "]H", desc = "[Git] Last hunk" },
              { "[i", desc = "[Indent] Scope top" },
              { "]i", desc = "[Indent] Scope bottom" },
              { "[n", desc = "[Node] Previous node" },
              { "]n", desc = "[Node] Next node" },
              { "[N", desc = "[Node] Previous sibling" },
              { "]N", desc = "[Node] Next sibling" },
              { "[%", desc = "[Match] Previous unmatched" },
              { "]%", desc = "[Match] Next unmatched" },
              { "ai", desc = "[Select] Indent scope (with border)" },
              { "ii", desc = "[Select] Indent scope" },
              { "an", desc = "[Node] Parent (outer)" },
              { "in", desc = "[Node] Child (inner)" },
              { "a%", desc = "[Match] Matched pair textobject" },
              -- g native motions (visual)
              { "gu", desc = "[Edit] Lowercase" },
              { "gU", desc = "[Edit] Uppercase" },
              { "g~", desc = "[Edit] Toggle case" },
              { "ge", desc = "[Nav] Previous word end" },
              { "gg", desc = "[Nav] First line" },
              { "gw", desc = "[Format] Reflow (format)" },
              { "gr", group = "LSP" },
              -- leader groups (visual)
              { "<leader>l", group = "LSP" },
              { "<leader>la", desc = "[LSP] Code action (Lspsaga)" },
              { "<leader>s", group = "Substitute" },
              -- Visual root: operators
              { "c", desc = "[Edit] Change" },
              { "d", desc = "[Edit] Delete" },
              { "y", desc = "[Edit] Yank" },
              { "r", desc = "[Edit] Replace" },
              { "~", desc = "[Edit] Toggle case" },
              { "<", desc = "[Edit] Indent left" },
              { ">", desc = "[Edit] Indent right" },
              { "!", desc = "[Edit] Filter through program" },
              -- Visual root: motions
              { "0", desc = "[Motion] Start of line" },
              { "^", desc = "[Motion] Start of line (non-blank)" },
              { "$", desc = "[Motion] End of line" },
              { "G", desc = "[Motion] Last line" },
              { "h", desc = "[Motion] Left" },
              { "j", desc = "[Motion] Down" },
              { "k", desc = "[Motion] Up" },
              { "l", desc = "[Motion] Right" },
              { "w", desc = "[Motion] Next word" },
              { "W", desc = "[Motion] Next WORD" },
              { "b", desc = "[Motion] Prev word" },
              { "B", desc = "[Motion] Prev WORD" },
              { "e", desc = "[Motion] Next word end" },
              { "E", desc = "[Motion] Next WORD end" },
              { "f", desc = "[Motion] To next char" },
              { "F", desc = "[Motion] To prev char" },
              { "t", desc = "[Motion] Before next char" },
              { "T", desc = "[Motion] Before prev char" },
              { ";", desc = "[Motion] Repeat f/t forward" },
              { ",", desc = "[Motion] Repeat f/t backward" },
              { "{", desc = "[Motion] Prev empty line" },
              { "}", desc = "[Motion] Next empty line" },
              { "%", desc = "[Match] Matching bracket" },
              -- Visual root: search
              { "/", desc = "[Search] Forward" },
              { "?", desc = "[Search] Backward" },
              { "#", desc = "[Search] Word under cursor (backward)" },
              { "*", desc = "[Search] Word under cursor (forward)" },
              -- Visual root: flash
              { "s", desc = "[Flash] Jump" },
              { "S", desc = "[Flash] Treesitter select" },
              { "R", desc = "[Flash] Treesitter search" },
              -- Visual root: scroll / macro / mode / buffer
              { "<PageUp>", desc = "[Scroll] Page up" },
              { "<PageDown>", desc = "[Scroll] Page down" },
              { "<C-b>", desc = "[Scroll] Page up" },
              { "<C-f>", desc = "[Scroll] Page down" },
              { "<C-d>", desc = "[Scroll] Half page down" },
              { "Q", desc = "[Macro] Run last macro on lines" },
              { "@", desc = "[Macro] Run macro on lines" },
              { "v", desc = "[Mode] Charwise visual" },
              { "V", desc = "[Mode] Linewise visual" },
              { "<C-s>", desc = "[Buffer] Save" },
            },
          }
        '';
      };

      register = {
        "<leader>c" = "+Git-Conflict";
        "<leader>d" = "+Debug";
        "<leader>dg" = "+Step";
        "<leader>dv" = "+Stacktrace";
        "<leader>fe" = "+Telescope emoji";
        "<leader>fls" = "+Symbols";
        "<leader>l" = "+LSP";
        "<leader>lv" = "+DocsView";
        "<leader>n" = "+Neotree";
        "<leader>r" = "+RemoteSSH";
        "<leader>S" = "+Session";
        "<leader>s" = "+Substitute";
        "<leader>t" = "+To...";
        "<leader>td" = "+ToDo";
        "<leader><leader>" = "+Buffer swap";
        "gr" = "+LSP";

        # Standalone entry missing from the preset
        "<C-w>p" = "Go to previous window";

        "[ " = "[Edit] Blank line above";
        "[<C-L>" = "[Nav] Prev loclist (other file)";
        "[<C-Q>" = "[Nav] Prev quickfix (other file)";
        "[<C-T>" = "[Nav] Previous preview-tag";
        "[A" = "[Nav] First arglist file";
        "[B" = "[Nav] First buffer";
        "[D" = "[Diag] First diagnostic in buffer";
        "[H" = "[Git] First hunk";
        "[L" = "[Nav] First loclist item";
        "[Q" = "[Nav] First quickfix item";
        "[T" = "[Nav] First tag";
        "[a" = "[Nav] Previous arglist file";
        "[b" = "[Nav] Previous buffer";
        "[c" = "[Code] Previous class";
        "[d" = "[Diag] Previous diagnostic";
        "[f" = "[Code] Previous function";
        "[h" = "[Git] Previous hunk";
        "[i" = "[Indent] Scope top";
        "[l" = "[Nav] Previous loclist item";
        "[q" = "[Nav] Previous quickfix item";
        "[t" = "[Nav] Previous tag";
        "[x" = "[Conflict] Previous conflict";

        "] " = "[Edit] Blank line below";
        "]<C-L>" = "[Nav] Next loclist (other file)";
        "]<C-Q>" = "[Nav] Next quickfix (other file)";
        "]<C-T>" = "[Nav] Next preview-tag";
        "]A" = "[Nav] Last arglist file";
        "]B" = "[Nav] Last buffer";
        "]D" = "[Diag] Last diagnostic in buffer";
        "]H" = "[Git] Last hunk";
        "]L" = "[Nav] Last loclist item";
        "]Q" = "[Nav] Last quickfix item";
        "]T" = "[Nav] Last tag";
        "]a" = "[Nav] Next arglist file";
        "]b" = "[Nav] Next buffer";
        "]c" = "[Code] Next class";
        "]d" = "[Diag] Next diagnostic";
        "]f" = "[Code] Next function";
        "]h" = "[Git] Next hunk";
        "]i" = "[Indent] Scope bottom";
        "]l" = "[Nav] Next loclist item";
        "]q" = "[Nav] Next quickfix item";
        "]t" = "[Nav] Next tag";
        "]x" = "[Conflict] Next conflict";

        "<leader>gc" = "[Neogit] Commit";
        "<leader>gs" = "[Neogit] Status";
        "<leader>gP" = "[Neogit] Push";
        "<leader>gp" = "[Neogit] Pull";
        "<leader>gg" = "[Lazygit] Open";

        "gc" = "[Comment] Toggle (motion)";
        "gcc" = "[Comment] Toggle line";
        "gh" = "[Git] Apply hunk";
        "gH" = "[Git] Reset hunk";
        "gS" = "[Edit] Split/join arguments";
        "gx" = "[Open] URL/file under cursor";
        "g*" = "[Search] Word under cursor, forward (substring)";
        "g#" = "[Search] Word under cursor, backward (substring)";

        "gu" = "[Edit] Lowercase";
        "gU" = "[Edit] Uppercase";
        "g~" = "[Edit] Toggle case";
        "gw" = "[Format] Reflow (format)";
        "gg" = "[Nav] First line";
        "gi" = "[Nav] Last insert position";
        "ge" = "[Nav] Previous word end";
        "gv" = "[Nav] Reselect last visual";
        "g;" = "[Nav] Newer change position";
        "g," = "[Nav] Older change position";
        "gt" = "[Tab] Next tab";
        "gT" = "[Tab] Previous tab";
        "gn" = "[Search] Next match + select";
        "gN" = "[Search] Previous match + select";
        "gf" = "[Open] File under cursor";
        "g%" = "[Match] Cycle backward through matches";

        "gO" = "[LSP] Document symbols (outline)";
        "gra" = "[LSP] Code action";
        "gri" = "[LSP] Go to implementation";
        "grn" = "[LSP] Rename symbol";
        "grr" = "[LSP] Find references";
        "grt" = "[LSP] Go to type definition";
        "grx" = "[LSP] Run codelens";

        "gz" = "[Surround] Add around motion";
        "gzd" = "[Surround] Delete pair";
        "gzr" = "[Surround] Change pair";
        "gzz" = "[Surround] Add around motion (new lines)";
        "gZ" = "[Surround] Add around line";
        "gZR" = "[Surround] Change pair (new lines)";
        "gZZ" = "[Surround] Add around line (new lines)";
        "za" = "[Fold] Toggle fold under cursor";
        "zA" = "[Fold] Toggle all folds under cursor";
        "zo" = "[Fold] Open fold under cursor";
        "zO" = "[Fold] Open all folds under cursor";
        "zc" = "[Fold] Close fold under cursor";
        "zC" = "[Fold] Close all folds under cursor";
        "zR" = "[Fold] Open all folds";
        "zM" = "[Fold] Close all folds";
        "zm" = "[Fold] Fold more";
        "zr" = "[Fold] Fold less";

        "zt" = "[Screen] Top this line";
        "z<CR>" = "[Screen] Top this line (first non-blank)";
        "zz" = "[Screen] Center this line";
        "zb" = "[Screen] Bottom this line";
        "ze" = "[Screen] Right this line";
        "zs" = "[Screen] Left this line";
        "zH" = "[Screen] Half screen to the left";
        "zL" = "[Screen] Half screen to the right";

        "z=" = "[Spell] Suggestions";
        "zg" = "[Spell] Add word to spell list";
        "zw" = "[Spell] Mark word as bad";
      };
    };
  };
}
