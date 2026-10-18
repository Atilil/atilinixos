_: {
  den.aspects.nvf.homeManager =
    # mini.indentscope: animated vertical line for the current indent scope;
    # complements indent-blankline (which draws all levels statically).
    {lib, ...}: let
      inherit (lib.generators) mkLuaInline;
    in {
      programs.nvf.settings.vim.mini.indentscope = {
        enable = false;
        setupOpts = {
          symbol = "┆";
          draw = {
            # Idle delay (ms) before drawing the scope
            delay = 100;
            # Smooth animation: quadratic in-out, 150ms for the whole draw
            # regardless of scope height (unit = "total").
            animation = mkLuaInline ''
              require('mini.indentscope').gen_animation.quadratic({ easing = 'in-out', duration = 150, unit = 'total' })
            '';
          };
        };
      };

      # Hide the indent scope on the dashboard (it draws over the ASCII header)
      programs.nvf.settings.vim.autocmds = [
        {
          desc = "Disable mini.indentscope on the dashboard";
          event = ["FileType"];
          pattern = ["dashboard"];
          callback =
            mkLuaInline
            "function() vim.b.miniindentscope_disable = true end";
        }
      ];
    };
}
