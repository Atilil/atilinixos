_: {
  den.aspects.elisa.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.kdePackages.elisa];
  };
}
