_: {
  den.aspects.nvf.homeManager = {lib, ...}: let
    inherit (lib.generators) mkLuaInline;
  in {
    programs.nvf.settings.vim = {
      keymaps = [
        {
          action = "<cmd>Oil<CR>";
          key = "<leader>o";
          mode = "n";
        }
      ];
      utility.oil-nvim = {
        enable = true;
        gitStatus.enable = true;
        setupOpts = {
          delete_to_trash = true;
          # The confirmation float only shows up for deletes
          skip_confirm_for_simple_edits = true;
          # Default opens a vertical split, shadowing the global <C-s> = :w
          keymaps."<C-s>" = false;
          view_options.show_hidden = true;
          watch_for_changes = true;
          columns = [
            (mkLuaInline ''{ "permissions", highlight = "Comment" }'')
            (mkLuaInline ''
                {
                "size",
                align = "right",
                highlight = function(value)
                  if value:match("G") then
                    return "DiagnosticError"
                  elseif value:match("M") then
                    return "DiagnosticWarn"
                  else
                    return "Comment"
                  end
                end
              }
            '')
            (mkLuaInline ''{ "mtime", highlight = "Comment" }'')
            "icon"
          ];
        };
      };
    };
  };
}
