_: {
  den.aspects.shell.homeManager = _: {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "noctalia";
        update_ms = 2000;
        theme_background = false;
        vim_keys = true;
        proc_tree = true;
        show_battery_watts = true;
      };
    };
  };
}
