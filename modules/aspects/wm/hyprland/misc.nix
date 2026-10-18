_: {
  den.aspects.hyprland.homeManager = _: {
    wayland.windowManager.hyprland.settings.config = {
      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        vrr = 0;
        mouse_move_enables_dpms = false;
        key_press_enables_dpms = true;
        focus_on_activate = true;
        disable_watchdog_warning = true;
        disable_splash_rendering = true;
      };
      cursor = {
        inactive_timeout = 3;
        hide_on_key_press = true;
        warp_on_change_workspace = 1;
      };
      ecosystem.no_donation_nag = true;
    };
  };
}
