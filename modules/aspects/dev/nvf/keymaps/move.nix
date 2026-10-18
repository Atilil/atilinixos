_: {
  den.aspects.nvf.homeManager = _: {
    # mini.move: move lines (Normal) and selections (Visual) with <A-hjkl>, reindenting.
    programs.nvf.settings.vim.mini.move = {
      enable = true;
      setupOpts = {
        options.reindent_linewise = true;
        mappings = {
          left = "<A-h>";
          right = "<A-l>";
          down = "<A-j>";
          up = "<A-k>";
          line_left = "<A-h>";
          line_right = "<A-l>";
          line_down = "<A-j>";
          line_up = "<A-k>";
        };
      };
    };
  };
}
