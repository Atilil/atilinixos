{inputs, ...}: {
  den.aspects.nvf.homeManager = {lib, ...}: let
    inherit (lib.generators) mkLuaInline;
    inherit (inputs.nvf.lib.nvim.dag) entryAfter;

    # Helpers building bufferline highlight links
    mkLink = attribute: highlight: {inherit attribute highlight;};
    mkFull = highlight: {
      fg = mkLink "fg" highlight;
      bg = mkLink "bg" highlight;
    };
    mkBg = highlight: {bg = mkLink "bg" highlight;};
    # Separator glyphs: fg must be a BACKGROUND tone
    mkSep = highlight: {
      fg = mkLink "bg" highlight;
      bg = mkLink "bg" highlight;
    };
    mkSelected = (mkBg "StatusLine") // {sp = mkLink "fg" "TablineUnderline";};
    severities = lib.concatMap (s: [s "${s}_diagnostic"]) ["hint" "info" "warning" "error"];
    segments =
      ["close_button" "numbers" "diagnostic" "modified" "duplicate" "pick" "separator"]
      ++ severities;
    selectedGroups = map (s: "${s}_selected") segments;
    visibleGroups = map (s: "${s}_visible") segments;
    defaultGroups = segments ++ ["trunc_marker" "group_label"];
  in {
    programs.nvf.settings.vim = {
      # TablineUnderline follows the worst diagnostic of the current buffer, falling back to
      # the theme primary color on clean buffers (the theme comes from noctalia/matugen).
      luaConfigRC.bufferline-underline-sync = entryAfter ["theme"] ''
        do
          local severity_hl = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
          local applied
          local function sync_underline()
            local counts = vim.diagnostic.count(0)
            local worst
            for sev = 1, 4 do
              if counts[sev] then
                worst = sev
                break
              end
            end
            local color
            if worst then
              color = vim.api.nvim_get_hl(0, { name = severity_hl[worst], link = false }).fg
            else
              local tabsel = vim.api.nvim_get_hl(0, { name = "TabLineSel", link = false })
              color = tabsel.fg or tabsel.bg
            end
            if color == applied then return end
            applied = color
            vim.api.nvim_set_hl(0, "TablineUnderline", { fg = color })
            local hls = require("bufferline.highlights")
            hls.reset_icon_hl_cache()
            hls.set_all(require("bufferline.config").update_highlights())
            vim.cmd.redrawtabline()
          end

          vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
            group = vim.api.nvim_create_augroup("BufferlineUnderlineSync", {}),
            callback = function()
              if vim.bo.buflisted then sync_underline() end
            end,
          })
          sync_underline()
        end
      '';

      tabline.nvimBufferline = {
        enable = true;
        setupOpts = {
          options = {
            mode = "buffers";
            themable = false;
            numbers = "buffer_id";
            sort_by = "id";
            separator_style = "thick";
            indicator = {
              style = "underline";
            };
            right_mouse_command = "vertical sbuffer %d";
            middle_mouse_command = "horizontal sbuffer %d";
            groups.items = mkLuaInline "{ require('bufferline.groups').builtin.pinned:with({ icon = '' }) }";
          };
          highlights =
            {
              fill = mkFull "StatusLineNC";
              background = mkFull "StatusLineNC";
              buffer_visible = mkFull "StatusLineNC";
              # sp follows TablineUnderline, or the underline breaks under the filetype icon
              buffer_selected =
                (mkFull "StatusLine")
                // {
                  bold = true;
                  italic = true;
                  sp = mkLink "fg" "TablineUnderline";
                };

              indicator_selected = (mkFull "StatusLine") // {sp = mkLink "fg" "TablineUnderline";};
              indicator_visible = mkFull "StatusLineNC";

              tab_selected = (mkFull "StatusLine") // {sp = mkLink "fg" "TablineUnderline";};

              group_separator = mkSep "StatusLineNC";
              offset_separator = mkSep "StatusLineNC";
            }
            // lib.genAttrs selectedGroups (_: mkSelected)
            // lib.genAttrs visibleGroups (_: mkBg "StatusLineNC")
            // lib.genAttrs defaultGroups (_: mkBg "StatusLineNC");
        };
      };
    };
  };
}
