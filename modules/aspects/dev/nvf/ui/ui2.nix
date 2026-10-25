_: {
  den.aspects.nvf.homeManager = _: {
    # Neovim has no default LspProgress display: forward it as a progress message,
    # which ui2 routes through targets.progress. The id makes each token update in place.
    programs.nvf.settings.vim.luaConfigRC.lsp-progress = ''
      vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(ev)
          local value = ev.data.params.value
          if type(value) ~= "table" then return end
          local text = value.message or "done"
          if value.title then text = value.title .. ": " .. text end
          vim.api.nvim_echo({ { text } }, false, {
            id = "lsp." .. ev.data.client_id .. "." .. ev.data.params.token,
            kind = "progress",
            source = "vim.lsp",
            title = value.title,
            status = value.kind ~= "end" and "running" or "success",
            percent = value.percentage,
          })
        end,
      })
    '';

    programs.nvf.settings.vim.ui.ui2 = {
      enable = true;
      setupOpts.msg = {
        targets = {
          "" = "msg";
          empty = "cmd";
          bufwrite = "msg";
          confirm = "cmd";
          emsg = "pager";
          echo = "msg";
          echomsg = "msg";
          echoerr = "pager";
          completion = "cmd";
          list_cmd = "pager";
          lua_error = "pager";
          lua_print = "msg";
          progress = "msg";
          rpc_error = "pager";
          quickfix = "msg";
          search_cmd = "cmd";
          search_count = "cmd";
          shell_cmd = "pager";
          shell_err = "pager";
          shell_out = "pager";
          shell_ret = "msg";
          undo = "msg";
          verbose = "pager";
          wildlist = "cmd";
          wmsg = "msg";
          typed_cmd = "cmd";
        };
        cmd.height = 0.5;
        dialog.height = 0.5;
        msg = {
          height = 0.3;
          timeout = 5000;
        };
        pager.height = 0.5;
      };
    };
  };
}
