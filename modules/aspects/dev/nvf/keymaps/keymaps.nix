_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim.keymaps = [
      {
        key = "<C-s>";
        mode = ["n" "i" "x"];
        action = ":w<CR>";
        desc = "Write/Save";
        silent = true;
      }
      {
        key = "<C-q>";
        mode = ["n"];
        action = ":q<CR>";
        desc = "Close window";
        silent = true;
      }
      {
        key = "<Tab>";
        mode = ["n"];
        action = ":bn<CR>";
        desc = "Next buffer";
        silent = true;
      }
      {
        key = "<S-Tab>";
        mode = ["n"];
        action = ":bp<CR>";
        desc = "Previous buffer";
        silent = true;
      }
      {
        key = "<C-Up>";
        mode = ["n"];
        action = "<C-u>";
        desc = "Scroll Up";
        noremap = false;
        silent = true;
      }
      {
        key = "<C-Down>";
        mode = ["n"];
        action = "<C-d>";
        desc = "Scroll Down";
        noremap = false;
        silent = true;
      }
      {
        key = "<leader>s.";
        mode = ["x" "n"];
        action = ":s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>";
        desc = "Replace word under cursor (line)";
        silent = true;
      }
      {
        key = "<leader>s>";
        mode = ["x" "n"];
        action = ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>";
        desc = "Replace word under cursor (everywhere)";
        silent = true;
      }
      {
        key = "<leader>sg";
        mode = ["x" "n"];
        action = ":%s/";
        desc = "Global substitute";
        silent = true;
      }
      {
        key = "<leader>ss";
        mode = ["x" "n"];
        action = ":s/";
        desc = "Line substitute";
        silent = true;
      }
      {
        key = "<leader>sG";
        mode = ["x" "n"];
        action = ":%s//gI<Left><Left><Left>";
        desc = "Global substitute (flags gI)";
        silent = true;
      }
      {
        key = "<leader>sS";
        mode = ["x" "n"];
        action = ":s//gI<Left><Left><Left>";
        desc = "Line substitute (flags gI)";
        silent = true;
      }
      {
        key = "q";
        mode = ["n"];
        action = "<Nop>";
        desc = "Disable accidental macro recording";
        silent = true;
      }
      {
        key = "<C-z>";
        mode = ["n" "x"];
        action = "<Nop>";
        desc = "Disable suspend: kitty sessions launch nvim without a parent shell to resume it";
        silent = true;
      }
      {
        key = "Q";
        mode = ["n"];
        action = "q";
        desc = "Macro recording";
        silent = true;
      }
      {
        key = "<Esc>";
        mode = ["n"];
        expr = true;
        lua = true;
        desc = "Clear search highlight";
        action = ''function() vim.cmd("nohls") return "<Esc>" end'';
      }
    ];
  };
}
