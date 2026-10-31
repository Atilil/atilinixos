_: {
  den.aspects.elisa.homeManager = {pkgs, ...}: {
    # Audio desktop player for mom
    home.packages = [pkgs.kdePackages.elisa];
  };
}
