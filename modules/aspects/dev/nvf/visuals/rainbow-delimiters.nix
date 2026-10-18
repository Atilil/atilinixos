_: {
  den.aspects.nvf.homeManager = {...}: {
    programs.nvf.settings.vim.visuals.rainbow-delimiters = {
      enable = true;
      setupOpts.highlight = [
        "RainbowDelimiterRed"
        "RainbowDelimiterYellow"
        "RainbowDelimiterBlue"
        "RainbowDelimiterOrange"
        "RainbowDelimiterGreen"
        "RainbowDelimiterViolet"
        "RainbowDelimiterCyan"
      ];
    };

    programs.nvf.settings.vim.luaConfigRC.rainbow-delimiters-highlights = ''
      local function set_rainbow_hl()
        vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
      end

      set_rainbow_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_rainbow_hl })

      local ok, hooks = pcall(require, "ibl.hooks")
      if ok then
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      end
    '';
  };
}
