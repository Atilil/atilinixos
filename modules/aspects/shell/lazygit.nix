_: {
  den.aspects.shell.homeManager = _: {
    programs.lazygit = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        gui = {
          nerdFontsVersion = 2;
          showFileIcons = true;
          mainPanelSplitMode = "vertical";
        };
        git = {
          autoFetch = true;
          parseEmoji = true;
          disableForcePushing = true;
        };
        services = {
          "forge.macopla.com" = "gitea:forge.macopla.com";
        };
        os.editPreset = "nvim";
        update.method = "never";
        disableStartupPopups = true;
      };
    };
  };
}
