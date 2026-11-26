_: {
  den.aspects.hyprland.homeManager = {
    # Border/group colors come from Noctalia's generated ~/.config/hypr/noctalia.lua.
    # pcall: a missing file (fresh install, template off) must not break the config.
    wayland.windowManager.hyprland.extraConfig = ''
      local ok, noctalia = pcall(require, "noctalia")
      if ok then noctalia.apply_theme() end
    '';
    programs.noctalia.settings.theme.templates = {
      builtin_ids = ["hyprland"];
      community_ids = ["hyprtoolkit"];
    };
  };
}
