_: {
  den.aspects.hyprland.homeManager = {pkgs, ...}: {
    xdg.systemDirs.data = ["${pkgs.adw-gtk3}/share"];

    # Border/group colors come from Noctalia's generated ~/.config/hypr/noctalia.lua.
    # pcall: a missing file (fresh install, template off) must not break the config.
    wayland.windowManager.hyprland.extraConfig = ''
      local ok, noctalia = pcall(require, "noctalia")
      if ok then noctalia.apply_theme() end
    '';

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "adwaita-dark";
    };

    gtk = {
      enable = true;
      gtk4.theme = null;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3-dark";
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };
  };
}
