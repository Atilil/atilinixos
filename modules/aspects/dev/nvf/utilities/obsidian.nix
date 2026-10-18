_: {
  den.aspects.nvf.homeManager = {config, ...}: {
    programs.nvf.settings.vim.notes.obsidian = {
      enable = true;
      setupOpts = {
        workspaces = [
          {
            name = "notes";
            path = "${config.home.homeDirectory}/Projets/notes";
          }
        ];
        # Must be false: render-markdown handles the UI
        ui.enable = false;
        # Suppress legacy_commands deprecation warning (removed in 4.0)
        legacy_commands = false;
      };
    };
  };
}
