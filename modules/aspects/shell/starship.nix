_: {
  den.aspects.shell = {
    homeManager = _: {
      programs = {
        starship = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };
      };
      xdg.configFile."starship.toml".source = ./starship.toml;
    };
  };
}
