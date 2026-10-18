_: {
  den.aspects.bitwarden = {
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.bitwarden-desktop];
    };

    # Its polkit action (system unlock) is only read from the system profile.
    os = {pkgs, ...}: {
      environment.systemPackages = [pkgs.bitwarden-desktop];
    };
  };
}
