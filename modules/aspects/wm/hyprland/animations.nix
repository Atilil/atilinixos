_: {
  den.aspects.hyprland.homeManager = _: {
    wayland.windowManager.hyprland.settings = {
      config.animations.enabled = true;

      curve = [
        {
          _args = [
            "easeOutQuint"
            {
              type = "bezier";
              points = [[0.23 1] [0.32 1]];
            }
          ];
        }
        {
          _args = [
            "easeInOutCubic"
            {
              type = "bezier";
              points = [[0.65 0.05] [0.35 0.95]];
            }
          ];
        }
      ];

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 5;
          bezier = "easeOutQuint";
          style = "slide";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 5;
          bezier = "easeOutQuint";
          style = "slide";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 7;
          bezier = "default";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 6;
          bezier = "easeInOutCubic";
          style = "slide";
        }
      ];
    };
  };
}
