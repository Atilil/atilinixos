_: {
  den.aspects.nvf.homeManager = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib.generators) mkLuaInline;
    # One keymap per telescope-symbols data source: <leader>fe + first letter
    symbolsKeymap = source: {
      key = "<leader>fe${builtins.substring 0 1 source}";
      mode = ["n"];
      action = "<cmd>lua require('telescope.builtin').symbols({ sources = { '${source}' } })<CR>";
      desc = "Symbols: ${source} [Telescope]";
      silent = true;
    };

    mkExt = {
      name,
      pkg ? "${name}-nvim",
    }: {
      inherit name;
      packages = [pkgs.vimPlugins."telescope-${pkg}"];
    };
  in {
    programs.nvf.settings.vim = {
      startPlugins = [pkgs.vimPlugins.telescope-symbols-nvim];
      keymaps =
        [
          {
            key = "<leader>fz";
            mode = ["n"];
            action = "<cmd>Telescope zoxide list<CR>";
            desc = "Zoxide jump [Telescope]";
            silent = true;
          }
          {
            key = "<leader>fu";
            mode = ["n"];
            action = "<cmd>Telescope undo<CR>";
            desc = "Undo tree [Telescope]";
            silent = true;
          }
        ]
        ++ map symbolsKeymap ["emoji" "gitmoji" "julia" "kaomoji" "latex" "math" "nerd"];

      telescope = {
        enable = true;
        setupOpts = {
          defaults = {
            layout_config.horizontal.prompt_position = "bottom";
            sorting_strategy = "descending";
          };
          # Compact centered menu for vim.ui.select (default takes ~90% of the screen)
          extensions."ui-select" = mkLuaInline ''
            {
              require("telescope.themes").get_dropdown {
                previewer = false,
                layout_config = { width = 0.4, height = 0.3 },
              },
            }
          '';
        };
        extensions = [
          (mkExt {
            name = "fzf";
            pkg = "fzf-native-nvim";
          })
          (mkExt {
            name = "zoxide";
            pkg = "zoxide";
          })
          (mkExt {name = "frecency";})
          (mkExt {name = "undo";})
          (mkExt {name = "ui-select";})
        ];
      };
    };
  };
}
