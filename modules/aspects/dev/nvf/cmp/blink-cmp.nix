_: {
  den.aspects.nvf.homeManager = {lib, ...}: let
    inherit (lib.generators) mkLuaInline;
    # <A-1>..<A-9>,<A-0> accept the Nth item of the menu directly
    idxKeymaps = lib.listToAttrs (lib.genList (i: let
        n = i + 1;
        key =
          if n == 10
          then "0"
          else toString n;
      in {
        name = "<A-${key}>";
        value = [(mkLuaInline "function(cmp) cmp.accept({ index = ${toString n} }) end")];
      })
      10);
  in {
    programs.nvf.settings.vim.autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      setupOpts = {
        enabled = mkLuaInline ''function() return vim.bo.filetype ~= "markdown" end'';

        cmdline = {
          enabled = true;
          keymap.preset = "cmdline";
          sources = ["buffer" "cmdline"];
          completion = {
            trigger = {
              show_on_blocked_trigger_characters = [];
              show_on_x_blocked_trigger_characters = [];
            };
            list.selection = {
              preselect = true;
              auto_insert = true;
            };
            menu = {
              auto_show = mkLuaInline "function(ctx, _) return ctx.mode == 'cmdwin' end";
            };
          };
        };

        keymap =
          {
            preset = "enter";
            "<C-y>" = ["select_and_accept" "fallback"];
          }
          // idxKeymaps;

        signature = {
          enabled = true;
          window.border = "single";
        };

        # Bridge blink.cmp's snippets source to LuaSnip (loaded in snippets.nix)
        snippets.preset = "luasnip";

        completion = {
          ghost_text.enabled = false;

          keyword.range = "full";

          documentation = {
            auto_show = true;
            auto_show_delay_ms = 500;
            window.border = "single";
            window.winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None";
          };

          list.selection = {
            preselect = false;
            auto_insert = true;
          };

          menu = {
            border = "solid";
            auto_show = true;
            scrollbar = false;
            winhighlight = "Normal:Normal,FloatBorder:String,CursorLine:BlinkCmpMenuSelection,Search:None";
            # Anchor the popup to the ui2 cmdline, falling back to the last screen line
            cmdline_position = mkLuaInline ''
              function()
                if vim.g.ui_cmdline_pos ~= nil then
                  local pos = vim.g.ui_cmdline_pos
                  return { pos[1], pos[2] }
                end
                local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                return { vim.o.lines - height, 0 }
              end
            '';
            # Show the item number in front of each entry (for <A-N>)
            draw = mkLuaInline ''
              {
                columns = {
                  { 'item_idx' },
                  { 'kind_icon' },
                  { 'label', 'label_description', gap = 1 },
                },
                components = {
                  item_idx = {
                    text = function(ctx) return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or tostring(ctx.idx) end,
                    highlight = 'BlinkCmpItemIdx',
                  },
                  -- INFO: Context-aware label coloring via colorful-menu.nvim
                  label = {
                    text = function(ctx) return require('colorful-menu').blink_components_text(ctx) end,
                    highlight = function(ctx) return require('colorful-menu').blink_components_highlight(ctx) end,
                  },
                },
              }
            '';
          };
        };

        fuzzy = {
          implementation = "prefer_rust_with_warning";
          sorts = ["exact" "score" "sort_text"];
        };

        sources = {
          providers.buffer = {
            score_offset = -7;
            # Complete from all normal (file) buffers, not just visible ones
            opts.get_bufnrs = mkLuaInline ''
              function()
                return vim.tbl_filter(function(bufnr)
                  return vim.bo[bufnr].buftype == ""
                end, vim.api.nvim_list_bufs())
              end
            '';
          };
          providers.snippets.score_offset = -3;
          default = ["lsp" "path" "snippets" "buffer"];
        };
      };
    };
  };
}
