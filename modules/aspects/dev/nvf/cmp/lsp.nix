_: {
  den.aspects.nvf.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    programs.nvf.settings.vim = {
      formatter.conform-nvim.setupOpts = {
        formatters_by_ft = {
          yaml = ["yamlfmt"];
          dockercompose = ["yamlfmt"];
        };
        formatters.yamlfmt = {
          command = "${pkgs.yamlfmt}/bin/yamlfmt";
          prepend_args = [
            "-formatter"
            (builtins.concatStringsSep "," [
              "retain_line_breaks_single=true" # keep blank lines between blocks
              "indent=4" # match the global 4-space style
              "indentless_arrays=true" # `- item` without extra indent
              "force_array_style=block" # expand inline [..] arrays to multi-line
              "force_quote_style=single" # single quotes (least escaping)
              "eof_newline=true" # always end with a newline
              "trim_trailing_whitespace=true" # drop trailing spaces
            ])
          ];
        };
      };

      luaConfigRC = {
        # Non-file buffers (diffview://, fugitive://): nixd rejects LSP requests on non-file URIs,
        # so turn auto inlay hints off there (deferred until after nvf's LspAttach handler enables them)
        inlay-hint-uri-fix = ''
          vim.api.nvim_create_autocmd("LspAttach", {
           callback = function(args)
            if vim.api.nvim_buf_get_name(args.buf):match("^%w+://") then
             vim.defer_fn(function()
             pcall(vim.lsp.inlay_hint.enable, false, { bufnr = args.buf })
             end, 100)
            end
           end,
           })
        '';

        ansible-filetype = ''
          vim.filetype.add({
           pattern = {
           [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
           [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
           [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
           [".*/roles/.*/defaults/.*%.ya?ml"] = "yaml.ansible",
           [".*/roles/.*/vars/.*%.ya?ml"] = "yaml.ansible",
           [".*/roles/.*/meta/.*%.ya?ml"] = "yaml.ansible",
           [".*/group_vars/.*"] = "yaml.ansible",
           [".*/host_vars/.*"] = "yaml.ansible",
           [".*/ansible/vars/.*%.ya?ml"] = "yaml.ansible",
           },
          })
        '';
      };

      lsp = {
        enable = true;
        otter-nvim.enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
        lspconfig.enable = true;
        lspkind.enable = false;
        nvim-docs-view.enable = true;
        trouble.enable = true;

        mappings = {
          goToDefinition = "<leader>lg";
          renameSymbol = "<F2>";
          codeAction = null; # bound to LSPSaga
          hover = "K";
          nextDiagnostic = null; # bound to LSPSaga
          previousDiagnostic = null; # bound to LSPSaga
          listImplementations = "<leader>lD";
          toggleFormatOnSave = "<leader>lt";
        };

        servers = {
          ansiblels.cmd = ["${pkgs.ansible-language-server}/bin/ansible-language-server" "--stdio"];
          basedpyright.settings.basedpyright.analysis.typeCheckingMode = "basic";
          yaml-language-server = {
            settings = {
              redhat.telemetry.enabled = false;
              yaml.format.enable = false;
              yaml.schemas = {
                kubernetes = [
                  "*deployment*.yml"
                  "*deployment*.yaml"
                  "*service*.yml"
                  "*service*.yaml"
                  "*ingress*.yml"
                  "*ingress*.yaml"
                  "*configmap*.yml"
                  "*configmap*.yaml"
                  "*pod*.yml"
                  "*pod*.yaml"
                ];
                "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json" = [".gitlab-ci.yml"];
              };
            };
          };
          gitlab-ci-ls.filetypes = lib.mkForce ["yaml.gitlab"];
        };
      };
    };
  };
}
