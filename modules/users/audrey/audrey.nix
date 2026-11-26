{den, ...}: {
  den.aspects.audrey = {
    includes = with den; [
      aspects.shell
      aspects.thunderbird
      aspects.whatsapp
      aspects.bitwarden
      aspects.plasma
      aspects.plasma-rice
      aspects.plasma-layout
      aspects.office
      aspects.jellyfin
      aspects.elisa
      aspects.immich
      aspects.family-desktop
    ];

    user = {config, ...}: {
      hashedPasswordFile = config.sops.secrets.audrey_password.path;
      extraGroups = ["networkmanager"];
    };
    homeManager = {
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
  };
}
