_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim = {
      luaConfigRC.noice-cmdline-color = ''
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "String" })
      '';

      ui.noice = {
        enable = true;
        setupOpts = {
          presets = {
            command_palette = true;
            long_message_to_split = true;
          };
          views.cmdline_popup.position = {
            row = "50%";
            col = "50%";
          };
        };
      };

      keymaps = [
        {
          key = "<leader>fn";
          mode = ["n"];
          action = "<cmd>Noice telescope<CR>";
          desc = "Noice error [Telescope]";
        }
      ];

      notify.nvim-notify = {
        enable = true;
        setupOpts = {
          background_colour = "#000000";
        };
      };
    };
  };
}
