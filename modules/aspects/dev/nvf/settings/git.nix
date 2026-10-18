_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim = {
      git = {
        enable = true;

        # Covered by other plugins
        gitsigns.enable = false;
        vim-fugitive.enable = false;

        neogit = {
          enable = true;
          # Start each time with clean flags
          setupOpts.remember_settings = false;
        };
        git-conflict.mappings = {
          prevConflict = "[x";
          nextConflict = "]x";
        };
      };
      mini.diff.enable = true;
      keymaps = [
        {
          key = "<leader>go";
          mode = "n";
          action = "function() require('mini.diff').toggle_overlay() end";
          lua = true;
          desc = "[MiniDiff] Toggle overlay";
        }
      ];
    };
  };
}
