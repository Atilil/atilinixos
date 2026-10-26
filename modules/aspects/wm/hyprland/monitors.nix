_: {
  den.aspects.hyprland.homeManager = _: {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        {
          output = "desc:LG Display 0x06E0";
          mode = "preferred";
          position = "0x0";
          scale = 1;
        }
        {
          output = "desc:LG Electronics 38GN950 307NTDV46930";
          mode = "3840x1600";
          position = "1920x0";
          scale = 1;
        }
        {
          output = "desc:Samsung Electric Company C49HG9x H4ZMC00740";
          mode = "3840x1080";
          position = "-3840x0";
          scale = 1;
          vrr = 1;
        }
        {
          output = "desc:LG Electronics 38GL950G 0x01010101";
          mode = "3840x1600";
          position = "1920x-1600";
          scale = 1;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

      config.render = {
        direct_scanout = 2;
      };
    };
  };
}
