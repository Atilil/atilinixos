_: {
  # Shared Plasma layout (panels, widgets); the look is plasma-rice.
  den.aspects.plasma-layout.homeManager = {
    config,
    lib,
    pkgs,
    ...
  }: let
    # Desktop widgets are placed on screen 0, centred for its resolution (Plasma snaps to 16 px).
    scr = config.plasmaLayout.screen;
    snap = v: (v + 8) / 16 * 16;
    dy = (scr.height - 900) / 2;
    dx = (scr.width - 1600) / 2;
  in {
    options.plasmaLayout.screen = {
      width = lib.mkOption {
        type = lib.types.int;
        description = "Resolution of the screen holding the desktop widgets.";
      };
      height = lib.mkOption {type = lib.types.int;};
    };

    # Dolphin and Gwenview are pinned in the dock below.
    config.home.packages = with pkgs.kdePackages; [dolphin gwenview];

    config.programs.plasma = {
      # Re-applied when this config changes. Offsets are maria's layout on 1600x900.
      desktop.widgets = [
        {
          name = "com.github.prayag2.modernclock";
          screen = 0;
          position = {
            horizontal = snap (400 + dx);
            vertical = snap (192 + dy);
          };
          size = {
            width = 800;
            height = 256;
          };
          config.Appearance = {
            use_24_hour_format = true;
            time_character = "";
            time_font_size = 40;
          };
        }
        {
          name = "Music.Waves";
          screen = 0;
          position = {
            horizontal = snap (624 + dx);
            vertical = snap (448 + dy);
          };
          size = {
            width = 576;
            height = 144;
          };
        }
      ];

      # Windows-like single bottom panel.
      panels = [
        {
          # Dock: pinned apps only, centred and fitted to its icons.
          location = "bottom";
          screen = "all";
          height = 60;
          floating = true;
          lengthMode = "fit";
          alignment = "center";
          opacity = "translucent";
          hiding = "autohide";
          widgets = [
            {
              iconTasks = {
                launchers = [
                  "applications:zen-beta.desktop"
                  "applications:helium.desktop"
                  "applications:thunderbird.desktop"
                  "applications:com.rtosta.zapzap.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.kde.gwenview.desktop"
                  "applications:org.jellyfin.JellyfinDesktop.desktop"
                  "applications:org.kde.elisa.desktop"
                  "applications:immich.desktop"
                  "applications:bitwarden.desktop"
                ];
                appearance.highlightWindows = true;
                behavior.middleClickAction = "close";
              };
            }
            "org.kde.plasma.marginsseparator"
          ];
        }
        {
          location = "top";
          screen = "all";
          height = 30;
          floating = true;
          widgets = [
            "org.kde.plasma.kicker"
            "org.kde.plasma.appmenu"
            "org.kde.plasma.panelspacer"
            "org.kde.plasma.digitalclock"
            "org.kde.plasma.panelspacer"
            "org.kde.plasma.pager"
            "org.kde.plasma.systemtray"
          ];
        }
      ];
    };
  };
}
