_: {
  den.aspects.taskwarrior.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.taskwarrior-tui];

    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      colorTheme = "dark-16";
    };
  };
}
