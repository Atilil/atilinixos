_: {
  den.aspects.elisa.homeManager = {pkgs, ...}: {
    # Audio desktop player
    home.packages = [pkgs.kdePackages.elisa];
  };
}
