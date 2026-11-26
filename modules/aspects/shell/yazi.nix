_: {
  den.aspects.shell = {
    homeManager = _: {
      programs = {
        yazi = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          shellWrapperName = "y";
        };
      };
    };
  };
}
