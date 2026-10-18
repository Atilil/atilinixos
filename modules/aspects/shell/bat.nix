_: {
  den.aspects.shell = {
    homeManager = _: {
      # Colorize man pages through bat
      home.sessionVariables = {
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        MANROFFOPT = "-c";
      };
      programs = {
        bat = {
          enable = true;
          config = {
            pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen";
            paging = "auto";
            theme = "base16";
            style = "full";
          };
        };
      };
    };
  };
}
