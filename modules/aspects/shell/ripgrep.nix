_: {
  den.aspects.shell = {
    homeManager = _: {
      programs = {
        ripgrep = {
          enable = true;
          arguments = [
            "--hidden"
            "--glob=!.git/*"
            "--smart-case"
            "--max-columns=150"
            "--max-columns-preview"
          ];
        };
      };
    };
  };
}
