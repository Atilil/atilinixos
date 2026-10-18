{inputs, ...}: {
  den.aspects.nvf.homeManager = _: let
    inherit (inputs.nvf.lib.nvim.dag) entryAfter;
  in {
    # Seamless split navigation between nvim and kitty (ctrl+hjkl); kitty side in
    # modules/aspects/shell/kitty/kitty.nix.
    programs.nvf.settings.vim.utility.smart-splits = {
      enable = true;
      # Default resize_* keys collide with mini.move
      keymaps = {
        resize_left = "<A-S-h>";
        resize_down = "<A-S-j>";
        resize_up = "<A-S-k>";
        resize_right = "<A-S-l>";
      };
    };

    # The VimEnter kitty snapshot is taken before the window is focused
    # in a fresh session; re-snapshot after startup.
    programs.nvf.settings.vim.luaConfigRC.smart-splits-kitty-refresh = entryAfter ["pluginConfigs"] ''
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          for _, delay in ipairs({ 250, 1000, 3000 }) do
            vim.defer_fn(function()
              pcall(function()
                require("smart-splits.mux").get().update_mux_layout_details()
              end)
            end, delay)
          end
        end,
      })
    '';
  };
}
