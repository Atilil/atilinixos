_: {
  den.aspects.dev.homeManager = {pkgs, ...}: {
    # nvf ships its own formatters; alejandra stays global for the `ale` alias run outside the repo
    home.packages = [pkgs.alejandra];
  };
}
