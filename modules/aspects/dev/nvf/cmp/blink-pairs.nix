_: {
  den.aspects.nvf.homeManager = {pkgs, ...}: {
    # blink-pairs: auto-pairs, rainbow highlighting disabled.
    programs.nvf.settings.vim.extraPlugins = {
      "blink-pairs".package = pkgs.vimPlugins.blink-pairs;
      "blink-pairs".setup =
        #lua
        ''
          require('blink-pairs').setup{
            highlights = {
              enabled = false,
            },
            -- INFO: Disable the wrap keymaps: <C-b> collides with neotree, and
            --       surround (gz) already covers "wrap this text in a pair".
            --       The register skips keys set to false.
            mappings = {
              wrap = {
                ['<C-b>'] = false,
                ['<C-S-b>'] = false,
              },
            },
          }
        '';
    };
  };
}
