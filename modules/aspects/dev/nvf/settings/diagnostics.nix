_: {
  den.aspects.nvf.homeManager = {
    lib,
    pkgs,
    ...
  }: {
    programs.nvf.settings.vim = {
      diagnostics = {
        enable = true;
        nvim-lint = {
          enable = true;
          linters.tflint.cmd = "${pkgs.tflint}/bin/tflint";
          linters_by_ft = {
            terraform = ["tflint"];
            # ruff (LSP) already lints Python, so mypy stays off
            python = [];
            # bash-language-server already bridges shellcheck; avoid duplicate SC diagnostics
            # from nvim-lint's own shellcheck run
            sh = [];
            bash = [];
          };
        };
        config = let
          sy = "vim.diagnostic.severity";
          inherit (lib.generators) mkLuaInline;
        in {
          underline = {
            enable = true;
            severity.min = mkLuaInline "${sy}.WARN";
          };
          virtual_lines = {
            enable = true;
            current_line = true;
          };
          virtual_text = false;
          update_in_insert = true;
          severity_sort = true;
          float = {
            source = "if_many";
            border = "rounded";
            show_header = false;
          };
          signs = {
            severity.min = mkLuaInline "${sy}.HINT";
            text = mkLuaInline ''
              {
              [${sy}.ERROR] = "",
              [${sy}.WARN] = "",
              [${sy}.INFO] = "",
              [${sy}.HINT] = "",
              }
            '';
          };
          "numhl" = mkLuaInline ''
            {
            [${sy}.ERROR] = "DiagnosticSignError",
            [${sy}.WARN] = "DiagnosticSignWarn",
            [${sy}.INFO] = "DiagnosticSignInfo",
            [${sy}.HINT] = "DiagnosticSignHint",
            }
          '';
        };
      };

      # Drop the built-in <C-w>d diagnostic float in favour of lspsaga
      luaConfigRC.drop-cw-diagnostics = ''
        pcall(vim.keymap.del, "n", "<C-w>d")
        pcall(vim.keymap.del, "n", "<C-w><C-d>")
      '';
    };
  };
}
