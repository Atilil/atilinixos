_: {
  den.aspects.nvf.homeManager = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      keymaps = [
        {
          key = "<A-o>";
          mode = ["n" "x" "o"];
          lua = true;
          desc = "Select parent treesitter node";
          action = ''
            function()
              if vim.treesitter.get_parser(nil, nil, { error = false }) then
                require("vim.treesitter._select").select_parent(vim.v.count1)
              else
                vim.lsp.buf.selection_range(vim.v.count1)
              end
            end
          '';
        }
        {
          key = "<A-i>";
          mode = ["n" "x" "o"];
          lua = true;
          desc = "Decrease select treesitter node";
          action = ''
            function()
              if vim.treesitter.get_parser(nil, nil, { error = false }) then
                require("vim.treesitter._select").select_child(vim.v.count1)
              else
                vim.lsp.buf.selection_range(-vim.v.count1)
              end
            end
          '';
        }
      ];
      visuals.hlargs-nvim.enable = true;
      treesitter = {
        enable = true;
        textobjects.enable = true;
        indent.excludes = ["yaml" "yaml.ansible" "yaml.docker-compose"];

        # Treesitter folds are available (za/zc/zM), but foldlevelstart=99 in
        # nvf.nix keeps every file fully unfolded on open.
        fold = true;

        # Orphan grammars only: filetypes with no `vim.languages.<lang>` module.
        grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
          c
          comment
          commonlisp
          diff
          fish
          git_rebase
          gitcommit
          gitignore
          ini
          kitty
          luadoc
          make
          requirements
          todotxt
          typescript
          vim
          vimdoc
          xml
          zsh
        ];

        # Inject highlighting in embedded code.
        queries = [
          {
            type = "injections";
            filetypes = ["nix"];
            loadtype = "extends";
            query = ''
              ;; NOTE: Lua string options
              ((apply_expression
                 function: (variable_expression name: (identifier) @_func)
                 argument: (indented_string_expression (string_fragment) @injection.content))
               (#eq? @_func "mkLuaInline")
               (#set! injection.language "lua")
               (#set! injection.combined))

              ((apply_expression
                 function: (variable_expression name: (identifier) @_func)
                 argument: (string_expression (string_fragment) @injection.content))
               (#eq? @_func "mkLuaInline")
               (#set! injection.language "lua")
               (#set! injection.combined))

              ((binding
                 attrpath: (attrpath (identifier) @_attr)
                 expression: (indented_string_expression (string_fragment) @injection.content))
               (#any-of? @_attr "luaConfigPre" "luaConfigPost")
               (#set! injection.language "lua")
               (#set! injection.combined))

              ((binding
                 attrpath: (attrpath (identifier) @_rc)
                 expression: (attrset_expression
                   (binding_set
                     (binding
                       expression: (indented_string_expression (string_fragment) @injection.content)))))
               (#eq? @_rc "luaConfigRC")
               (#set! injection.language "lua")
               (#set! injection.combined))

              ;; NOTE: kitty.conf syntax (programs.kitty.extraConfig).
              ((binding
                 attrpath: (attrpath (identifier) @_attr)
                 expression: (indented_string_expression (string_fragment) @injection.content))
               (#eq? @_attr "extraConfig")
               (#set! injection.language "kitty")
               (#set! injection.combined))
            '';
          }
        ];
      };

      luaConfigPost = ''
        -- Helm only when a Chart.yaml sits above; priority beats the generic
        -- templates/ -> yaml.gitlab rule, and nil falls through to it.
        vim.filetype.add({
          pattern = {
            [".*/templates/.*%.ya?ml"] = {
              function(path)
                local chart = vim.fs.find("Chart.yaml", { upward = true, path = vim.fs.dirname(path), type = "file" })[1]
                return chart and "helm" or nil
              end,
              { priority = 10 },
            },
          },
        })

        -- NOTE: Treesitter text objects: main-branch API needs manual keymaps.
        require('nvim-treesitter-textobjects').setup({
          select = { lookahead = true },
          move = { set_jumps = true },
        })
        local sel = require('nvim-treesitter-textobjects.select')
        local mv = require('nvim-treesitter-textobjects.move')

        -- NOTE: select (operator-pending + visual): daf, cif, via, ...
        for lhs, spec in pairs({
          af = { '@function.outer', 'Function (outer)' },
          ['if'] = { '@function.inner', 'Function (inner)' },
          ac = { '@class.outer', 'Class (outer)' },
          ic = { '@class.inner', 'Class (inner)' },
          aa = { '@parameter.outer', 'Parameter (outer)' },
          ia = { '@parameter.inner', 'Parameter (inner)' },
        }) do
          vim.keymap.set({ 'x', 'o' }, lhs, function()
            sel.select_textobject(spec[1], 'textobjects')
          end, { desc = '[Select] ' .. spec[2] })
        end

        -- NOTE: move (normal + visual + operator-pending)
        -- Class uses ]k/[k: ]c/[c are Neovim's built-in diff-hunk motions.
        vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() mv.goto_next_start('@function.outer', 'textobjects') end, { desc = '[Code] Next function' })
        vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() mv.goto_previous_start('@function.outer', 'textobjects') end, { desc = '[Code] Previous function' })
        vim.keymap.set({ 'n', 'x', 'o' }, ']k', function() mv.goto_next_start('@class.outer', 'textobjects') end, { desc = '[Code] Next class' })
        vim.keymap.set({ 'n', 'x', 'o' }, '[k', function() mv.goto_previous_start('@class.outer', 'textobjects') end, { desc = '[Code] Previous class' })
      '';
    };
  };
}
