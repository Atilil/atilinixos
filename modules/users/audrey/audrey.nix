{den, ...}: {
  den.aspects.audrey = {
    includes = with den; [
      (batteries.import-tree ./hm)
      aspects.shell
      aspects.thunderbird
      aspects.bitwarden
      aspects.plasma
      aspects.plasma-rice
      aspects.plasma-layout
      aspects.office
      aspects.jellyfin
      aspects.elisa
      aspects.immich
    ];

    homeManager = _: {
      # Laptop panel (eDP-1); the dock and top panel go on every screen.
      plasmaLayout.screen = {
        width = 1920;
        height = 1080;
      };
      # French ISO only (the system keeps yoann's us,fr).
      programs.plasma.input.keyboard.layouts = [{layout = "fr";}];

      userInfo = {
        realName = "Audrey";
        emails = {
          primary = "audrey" + "@" + "macopla.com";
          secondary = "audreyplaneau" + "@" + "gmail.com";
          tertiary = "audreyplaneau" + "@" + "yahoo.fr";
          instagram = "green.beauty.girondine" + "@" + "gmail.com";
        };
      };
    };

    user = {config, ...}: {
      hashedPasswordFile = config.sops.secrets.audrey_password.path;
      extraGroups = ["networkmanager"];
    };
  };
}
