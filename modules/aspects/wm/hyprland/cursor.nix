_: {
  # The XCursor theme itself is set in the desktop-theme aspect.
  den.aspects.hyprland.homeManager = {config, ...}: {
    xdg.configFile."uwsm/env".text = ''
      export HYPRCURSOR_THEME=Nordzy-hyprcursors
      export HYPRCURSOR_SIZE=${toString config.home.pointerCursor.size}
    '';
  };
}
