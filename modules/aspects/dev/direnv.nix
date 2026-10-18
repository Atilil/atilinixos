_: {
  den.aspects.dev.homeManager = _: {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
