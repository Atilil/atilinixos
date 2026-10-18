_: {
  den.aspects.gaming = {
    os = {pkgs, ...}: {
      programs = {
        steam = {
          enable = true;
          extest.enable = true;
          protontricks.enable = true;
        };
        gamemode = {
          enable = true;
          enableRenice = true;
          settings = {
            general.renice = 10;
            custom = {
              start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
              end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
            };
          };
        };
      };
      environment.systemPackages = [pkgs.moonlight-qt];
    };
  };
}
