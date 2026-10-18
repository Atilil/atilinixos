_: {
  den.aspects.jellyfin.homeManager = {pkgs, ...}: {
    # Jellyfin client; the server is entered at first launch.
    home.packages = [pkgs.jellyfin-desktop];
  };
}
