_: {
  den.aspects.hyprland.homeManager = {pkgs, ...}: {
    home.pointerCursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 32;
      gtk.enable = true;
    };
    xdg.configFile."uwsm/env".text = ''
      export HYPRCURSOR_THEME=Nordzy-hyprcursors
      export HYPRCURSOR_SIZE=32
    '';
  };
}
