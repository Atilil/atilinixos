_: {
  den.aspects.nvf.homeManager = {lib, ...}: {
    programs.nvf.settings.vim.statusline.lualine = {
      enable = true;
      setupOpts = {
        # Empty statusline when focus is on the neotree
        extensions = ["neo-tree"];

        options.section_separators = {
          left = "";
          right = "";
        };
        options.component_separators = {
          left = "";
          right = "";
        };

        # lsp_status instead of the default LSP-name-only component.
        # Raw Lua needs mkLuaInline: otherwise toLuaObject emits a quoted string that lualine
        # evaluates into a table at runtime.
        sections.lualine_x = map lib.generators.mkLuaInline [
          ''
            {
              "lsp_status",
            }
          ''
          ''
            {
              "diagnostics",
              sources = {'nvim_diagnostic'},
              symbols = {error = '󰅙  ', warn = '⚠  ', info = '🛈  ', hint = '󰌵  '},
              colored = true,
              update_in_insert = false,
              always_visible = false,
            }
          ''
        ];

        # Show the file encoding only when not utf-8, appended after the module defaults:
        # mkOptionDefault matches the default priority so it merges instead of replacing,
        # mkAfter orders it last.
        sections.lualine_z = lib.mkOptionDefault (lib.mkAfter (map lib.generators.mkLuaInline [
          ''
            {
              "encoding",
              cond = function()
                return vim.bo.fileencoding ~= "" and vim.bo.fileencoding ~= "utf-8"
              end,
            }
          ''
        ]));
      };
    };
  };
}
