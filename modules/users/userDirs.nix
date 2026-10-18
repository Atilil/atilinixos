_: {
  den.aspects.userDirs.homeManager = {config, ...}: {
    # NOTE: Force English XDG user dirs uniformly.
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      projects = "${config.home.homeDirectory}/Projets";
      templates = "${config.home.homeDirectory}/Templates";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };
}
