_: {
  den.aspects.dev.homeManager = {flakePath, ...}: {
    programs.nh = {
      enable = true;
      homeFlake = flakePath;
      osFlake = flakePath;
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };
  };
}
