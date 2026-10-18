_: {
  den.aspects.nvf.homeManager = _: {
    # Highlight every instance of the word under the cursor in the visible area, after a short idle delay
    programs.nvf.settings.vim.mini.cursorword = {
      enable = true;
      setupOpts = {
        delay = 1000;
      };
    };
  };
}
