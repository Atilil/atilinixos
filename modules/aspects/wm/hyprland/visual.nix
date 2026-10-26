_: {
  den.aspects.hyprland.homeManager = _: {
    wayland.windowManager.hyprland.settings.config = {
      general = {
        gaps_out = 10;
        border_size = 2;
        snap = {
          enabled = true;
          respect_gaps = true;
        };
      };

      decoration = {
        rounding = 12;
        shadow = {
          range = 6;
          color = "rgba(1e1e2eaa)";
        };
        blur = {
          size = 4;
          passes = 2;
          vibrancy = 1;
        };
      };

      group = {
        drag_into_group = 2;
        merge_floated_into_tiled_on_groupbar = true;
        groupbar = {
          height = 10;
        };
      };

      layout.single_window_aspect_ratio = "16 9";
      dwindle.preserve_split = true;
      master = {
        mfact = 0.65;
        new_on_top = true;
        orientation = "right";
      };
    };
  };
}
