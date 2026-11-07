_: {
  den.aspects.nvf.homeManager = {lib, ...}: let
    inherit (lib.generators) mkLuaInline;
  in {
    programs.nvf.settings.vim.autocmds = [
      {
        desc = "Highlight yank";
        event = ["textyankpost"];
        pattern = ["*"];
        callback =
          mkLuaInline
          ''function() vim.hl.on_yank({ higroup = 'visual', timeout = 300 }) end'';
      }
      {
        desc = "Preserve last editing position";
        event = ["BufReadPost"];
        pattern = ["*"];
        callback =
          mkLuaInline
          ''function() if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then vim.cmd("normal! g'\"") end end'';
      }
      {
        desc = "Quickly exit help pages";
        event = ["FileType"];
        pattern = ["help" "checkhealth"];
        callback =
          mkLuaInline
          ''function() vim.keymap.set("n", "q", "<cmd>close<cr>", { silent = true, buffer = true, }) end'';
      }
      {
        desc = "Nix 2-space indent";
        event = ["FileType"];
        pattern = ["nix"];
        callback =
          mkLuaInline
          ''function() vim.opt_local.shiftwidth = 2 vim.opt_local.tabstop = 2 vim.opt_local.softtabstop = 2 end'';
      }
      {
        desc = "YAML: keep indent after a trailing backslash (shell in block scalars)";
        event = ["FileType"];
        pattern = ["yaml" "yaml.ansible" "yaml.docker-compose" "yaml.gitlab"];
        callback =
          mkLuaInline
          ''
            function()
              -- GetYAMLIndent reads `" \` as an escaped multiline YAML string and
              -- aligns on the closing quote; in a `run: |` block it is shell.
              vim.cmd([[
                function! YamlShellIndent(lnum) abort
                  let p = prevnonblank(a:lnum - 1)
                  if p > 0 && getline(p) =~# '\\\s*$'
                    return indent(p)
                  endif
                  if exists('*GetYAMLIndent')
                    return GetYAMLIndent(a:lnum)
                  endif
                  return indent(p)
                endfunction
              ]])
              vim.opt_local.indentexpr = "YamlShellIndent(v:lnum)"
            end
          '';
      }
      {
        desc = "Nix: pair { with }; (cursor inside)";
        event = ["FileType"];
        pattern = ["nix"];
        callback =
          mkLuaInline
          ''function() vim.keymap.set('i', '{', '{};<Left><Left>', { buffer = true, silent = true }) end'';
      }
      {
        desc = "Force-check for external file changes (autoread only checks lazily)";
        event = ["FocusGained" "BufEnter"];
        pattern = ["*"];
        callback =
          mkLuaInline
          "function() vim.cmd('checktime') end";
      }
    ];
  };
}
