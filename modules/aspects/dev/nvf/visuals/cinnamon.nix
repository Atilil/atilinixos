_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim = {
      visuals.cinnamon-nvim = {
        enable = true;
        setupOpts = {
          keymaps = {
            basic = true;
            extra = true;
          };
          options = {
            mode = "window";
            step_size = {
              vertical = 1;
              horizontal = 2;
            };
          };
        };
      };
    };
  };
}
