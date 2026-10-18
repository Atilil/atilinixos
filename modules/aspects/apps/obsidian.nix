{den, ...}: {
  den.aspects.obsidian = {
    includes = [(den.batteries.insecure ["electron-39.8.10"])]; # HACK: delete when updated to electron_40

    homeManager = _: {
      programs.obsidian = {
        enable = true;
        cli.enable = true;
      };
    };
  };
}
