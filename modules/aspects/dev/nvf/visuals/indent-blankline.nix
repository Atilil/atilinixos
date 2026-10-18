_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim.visuals = {
      blink-indent.enable = false;
      indent-blankline = {
        enable = true;
        setupOpts = {
          whitespace.remove_blankline_trail = true;
          indent = {
            char = "▏";
            highlight = [
              "RainbowDelimiterRed"
              "RainbowDelimiterYellow"
              "RainbowDelimiterBlue"
              "RainbowDelimiterOrange"
              "RainbowDelimiterGreen"
              "RainbowDelimiterViolet"
              "RainbowDelimiterCyan"
            ];
          };
          scope = {
            char = "▏";
            show_exact_scope = false;
            show_start = true;
            show_end = true;
            highlight = [
              "RainbowDelimiterRed"
              "RainbowDelimiterYellow"
              "RainbowDelimiterBlue"
              "RainbowDelimiterOrange"
              "RainbowDelimiterGreen"
              "RainbowDelimiterViolet"
              "RainbowDelimiterCyan"
            ];
          };
          exclude = {
            buftypes = ["terminal"];
            filetypes = ["ts_context" "dashboard" "nvimtree"];
          };
        };
      };
    };
  };
}
