_: {
  # Compositor-agnostic look: GTK/Qt theme and cursor. Compositor-specific bits
  # (hyprcursor, Noctalia compositor templates) stay in the compositor aspect.
  den.aspects.desktop-theme.homeManager = {pkgs, ...}: {
    xdg.systemDirs.data = ["${pkgs.adw-gtk3}/share"];

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "adwaita-dark";
    };

    gtk = {
      enable = true;
      gtk4.theme = null;
      colorScheme = "dark";
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3-dark";
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    home.pointerCursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 32;
      gtk.enable = true;
    };
  };
}
