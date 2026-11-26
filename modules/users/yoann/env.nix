_: {
  den.aspects.yoann.homeManager = {pkgs, ...}: {
    home.sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      GDK_BACKEND = "wayland,x11";
      MOZ_ENABLE_WAYLAND = "1";
      OZONE_PLATFORM = "wayland";
    };

    # HACK: nixpkgs bug: the firefox/thunderbird wrapper no longer sets these gsettings schema paths,
    # breaking GTK/Pango text rendering on non-GNOME sessions
    xdg.systemDirs.data = [
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    ];
  };
}
