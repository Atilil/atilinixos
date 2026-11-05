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
        os = {
          editPreset = "nvim";
          # Detach: a browser started cold would stay a child lazygit waits on
          openLink = "setsid -f xdg-open {{link}} >/dev/null 2>&1";
          open = "setsid -f xdg-open {{filename}} >/dev/null 2>&1";
        };
        update.method = "never";
        disableStartupPopups = true;
      };
    };
  };
}
