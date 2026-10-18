_: {
  den.aspects.nvf.homeManager = {lib, ...}: let
    inherit (lib.generators) mkLuaInline;
  in {
    programs.nvf.settings.vim = {
      mini.trailspace = {
        enable = true;
        setupOpts = {
          only_in_normal_buffers = true;
        };
      };

      keymaps = [
        {
          key = "gW";
          mode = ["n"];
          lua = true;
          desc = "[Format] Trim trailing whitespace";
          action = "function() require('mini.trailspace').trim() end";
        }
      ];

      autocmds = [
        {
          desc = "Trim trailing whitespace on save";
          event = ["BufWritePre"];
          pattern = ["*"];
          callback =
            mkLuaInline
            "function() require('mini.trailspace').trim() end";
        }
      ];
    };
  };
}
