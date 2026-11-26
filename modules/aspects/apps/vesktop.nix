_: {
  den.aspects.vesktop.homeManager = _: {
    programs.vesktop = {
      enable = true;
      settings = {
        discordbranch = "stable";
        tray = true;
        minimizeToTray = true;
        autoStartMinimized = true;
        openLinkWithElectron = false;
        staticTitle = false;
        enableMenu = true;
        disableSmoothScroll = false;
        hardwareAcceleration = true;
        hardwareVideoAcceleration = true;
        arRPC = true;
        appBadges = true;
        enableTaskbarFlashing = false;
        disableMinSize = true;
        clickTrayToShowHide = true;
        customTitlebar = false;
        enableSpashScreen = false;
        spellCheckLanguages = ["en-US,fr-FR"];
      };
      vencord = {
        settings = {
          autoUpdate = true;
          autoUpdateNotifications = true;
        };
        useSystem = false;
      };
    };
  };
}
