_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim = {
      lsp.lspsaga = {
        enable = true;
        setupOpts = {
          lightbulb.enable = false;
        };
      };

      keymaps = [
        {
          key = "<leader>la";
          mode = ["n" "x"];
          action = "<cmd>Lspsaga code_action<CR>";
          desc = "Code action (Lspsaga)";
          silent = true;
        }
        {
          key = "<leader>]";
          mode = ["n"];
          action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
          desc = "Next diagnostic (Lspsaga)";
          silent = true;
        }
        {
          key = "<leader>[";
          mode = ["n"];
          action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
          desc = "Previous diagnostic (Lspsaga)";
          silent = true;
        }
      ];
    };
  };
}
