_: {
  den.aspects.nvf.homeManager =
    # mini.bufremove: delete buffers while preserving the window layout
    _: {
      programs.nvf.settings.vim = {
        mini.bufremove.enable = true;

        keymaps = [
          {
            key = "<leader>bd";
            mode = ["n"];
            lua = true;
            desc = "Delete current buffer (keep split)";
            action = "function() require('mini.bufremove').delete(0) end";
          }
          {
            key = "<leader>bo";
            mode = ["n"];
            lua = true;
            desc = "Delete other buffers (keep split)";
            action = ''
              function()
                local cur = vim.api.nvim_get_current_buf()
                for _, b in ipairs(vim.api.nvim_list_bufs()) do
                  if b ~= cur and vim.bo[b].buflisted then
                    require('mini.bufremove').delete(b)
                  end
                end
              end
            '';
          }
        ];
      };
    };
}
