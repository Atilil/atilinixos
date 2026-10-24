_: {
  den.aspects.nvf.homeManager = {lib, ...}: let
    inherit (lib.generators) mkLuaInline;
  in {
    programs.nvf.settings.vim = {
      opts.sessionoptions = "blank,buffers,curdir,folds,globals,help,tabpages,winsize";

      # Save and restore the neotree state
      luaConfigRC.session-restore-helpers = ''
        function __session_snapshot_and_close()
          local neotree_open = false
          for _, w in ipairs(vim.api.nvim_list_wins()) do
            if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "neo-tree" then
              neotree_open = true
              break
            end
          end
          vim.g.SessionNeotreeOpen = neotree_open and 1 or 0

          local ok, term = pcall(require, "toggleterm.terminal")
          local t = ok and term.get(1)
          vim.g.SessionTermOpen = (t ~= nil and t:is_open()) and 1 or 0

          if neotree_open then
            vim.cmd("Neotree close")
          end
        end

        function __session_restore_state()
          if vim.g.SessionNeotreeOpen == 1 then
            vim.cmd("Neotree show filesystem left")
          end
          if vim.g.SessionTermOpen == 1 then
            vim.cmd("1ToggleTerm")
          end
        end
      '';

      mini.sessions = {
        enable = true;
        setupOpts = {
          autoread = false;
          autowrite = true;
          hooks = {
            pre.write = mkLuaInline "function() __session_snapshot_and_close() end";
            post.write = mkLuaInline "function() __session_restore_state() end";
            post.read = mkLuaInline "function() __session_restore_state() end";
          };
        };
      };

      keymaps = [
        {
          key = "<leader>Sc";
          mode = "n";
          lua = true;
          desc = "Save session for current directory";
          action = ''function() require("mini.sessions").write(require("mini.sessions").config.file, { force = true }) end'';
        }
        {
          key = "<leader>Sl";
          mode = "n";
          lua = true;
          desc = "Load last session (local to cwd if present, else latest)";
          action = ''function() require("mini.sessions").read() end'';
        }
        {
          key = "<leader>Ss";
          mode = "n";
          lua = true;
          desc = "Select and load a session";
          action = ''function() require("mini.sessions").select("read") end'';
        }
        {
          key = "<leader>Sd";
          mode = "n";
          lua = true;
          desc = "Select and delete a session";
          action = ''function() require("mini.sessions").select("delete") end'';
        }
      ];
    };
  };
}
