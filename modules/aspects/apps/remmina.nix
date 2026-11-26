_: {
  den.aspects.remmina.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.remmina];
  };
}
