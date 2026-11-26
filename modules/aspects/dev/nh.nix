_: {
  den.aspects.dev.homeManager = {flakePath, ...}: {
    programs.nh = {
      enable = true;
      homeFlake = flakePath;
      osFlake = flakePath;
    };
  };
}
