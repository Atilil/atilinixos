_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim.visuals.nvim-scrollbar = {
      enable = false;
      setupOpts.excluded_filetypes = [
        "blink-cmp-menu"
        "blink-cmp-documentation"
        "blink-cmp-signature"
        "dropbar_menu"
        "dropbar_menu_fzf"
        "DressingInput"
        "cmp_docs"
        "cmp_menu"
        "prompt"
        "TelescopePrompt"
      ];
    };
  };
}
