{den, ...}: {
  den.aspects.maria = {
    includes = with den; [
      aspects.plasma
      aspects.plasma-rice
      aspects.plasma-layout
      aspects.remote-access
      aspects.bitwarden
      aspects.thunderbird
      aspects.whatsapp
      aspects.office
      aspects.jellyfin
      aspects.elisa
      aspects.immich
      aspects.family-desktop
    ];

    user = {
      description = "Maria";
      extraGroups = ["networkmanager" "wheel"];
    };
    homeManager.userInfo.realName = "Maria";
  };
}
