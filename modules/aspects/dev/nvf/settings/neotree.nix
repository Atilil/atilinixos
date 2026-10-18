_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim = {
      filetree.neo-tree = {
        enable = true;
        setupOpts = {
          sources = ["filesystem" "buffers" "git_status" "document_symbols"];
          auto_clean_after_session_restore = true;
          add_blank_line_at_top = true;
          default_source = "last";
          enable_cursor_hijack = false;
          enable_diagnostics = true;
          enable_git_status = true;
          enable_modified_markers = true;
          enable_opened_markers = true;
          enable_refresh_on_write = true;
          git_status_async = true;
          open_files_do_not_replace_types = ["terminal" "qf" "edgy" "Trouble"];
          open_files_in_last_window = true;
          close_if_last_window = true;
          hide_root_node = false;
          enable_image_preview = true;
          popup_border_style = "";
          filesystem = {
            group_empty_dirs = false;
            use_libuv_file_watcher = true;
            follow_current_file = {
              enabled = true;
              leave_dirs_open = true;
            };
          };
        };
      };
      keymaps = [
        {
          key = "<Leader>ne";
          mode = ["n"];
          action = ":Neotree show filesystem toggle left reveal<CR>";
          desc = "[Neotree] Toggle Neotree";
          silent = true;
        }
        {
          key = "<C-e>";
          mode = ["n"];
          action = ":Neotree filesystem toggle float reveal<CR>";
          desc = "Toggle floating Neotree";
          silent = true;
        }
        {
          key = "<Leader>nb";
          mode = ["n"];
          action = ":Neotree show buffers toggle left<CR>";
          desc = "[Neotree] Toggle Neotree buffer";
          silent = true;
        }
        {
          key = "<C-b>";
          mode = ["n"];
          action = ":Neotree buffers toggle float<CR>";
          desc = "Toggle floating Neotree";
          silent = true;
        }
        {
          key = "<Leader>ng";
          mode = ["n"];
          action = ":Neotree show git_status toggle left<CR>";
          desc = "[Neotree] Toggle Neotree git status";
          silent = true;
        }
        {
          key = "<Leader>ns";
          mode = ["n"];
          action = ":Neotree show document_symbols toggle left<CR>";
          desc = "[Neotree] Toggle Neotree document symbols";
          silent = true;
        }
      ];
    };
  };
}
