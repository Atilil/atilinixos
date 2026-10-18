_: {
  den.aspects.shell = {
    homeManager = _: {
      programs = {
        yazi = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          # `y` opens yazi and cd's into the last dir on quit
          shellWrapperName = "y";
          # `theme` left unset on purpose: Noctalia owns
          # ~/.config/yazi/theme.toml and flavors/noctalia.yazi
        };
      };
    };
  };
}
