_: {
  # RDP client to assist the family fleet (e.g. ideapad over the VPN).
  # Profiles stay GUI-managed: Remmina rewrites them.
  den.aspects.remmina.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.remmina];
  };
}
