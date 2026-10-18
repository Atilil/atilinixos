_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim = {
      utility.diffview-nvim.enable = true;
      keymaps = [
        {
          key = "<leader>gd";
          mode = "n";
          action = "<cmd>DiffviewOpen<CR>";
          desc = "[Diffview] Diff working tree";
        }
        {
          key = "<leader>gh";
          mode = "n";
          action = "<cmd>DiffviewFileHistory %<CR>";
          desc = "[Diffview] Current file history";
        }
        {
          key = "<leader>gq";
          mode = "n";
          action = "<cmd>DiffviewClose<CR>";
          desc = "[Diffview] Close";
        }
      ];
    };
  };
}
