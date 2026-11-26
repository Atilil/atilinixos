_: {
  den.aspects.jellyfin.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.jellyfin-desktop];
  };
}
