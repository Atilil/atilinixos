_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim.notes.todo-comments = {
      enable = true;
      setupOpts = {
        highlight.keyword = "wide_bg";
        highlight.multiline = true;
        colors = {
          error = ["DiagnosticError" "#DC2626"];
          warning = ["DiagnosticWarn" "#FBBF24"];
          info = ["DiagnosticInfo" "#2563EB"];
          hint = ["DiagnosticHint" "#10B981"];
          default = ["Identifier" "#7C3AED"];
          test = ["DiagnosticOk" "#10B981"];
        };
      };
    };
  };
}
