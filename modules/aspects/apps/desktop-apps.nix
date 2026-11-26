_: {
  # Per-user viewers and their file associations. Kept out of the host so KDE users
  # get Plasma's own defaults: /etc/xdg/mimeapps.list would override kde-mimeapps.list.
  den.aspects.desktop-apps.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      kdePackages.gwenview
      kdePackages.ark
      kdePackages.filelight
      haruna
      zathura
    ];

    xdg.mimeApps.defaultApplications = let
      gwenview = "org.kde.gwenview.desktop";
      haruna = "org.kde.haruna.desktop";
      ark = "org.kde.ark.desktop";
    in {
      "image/png" = gwenview;
      "image/jpeg" = gwenview;
      "image/gif" = gwenview;
      "image/webp" = gwenview;
      "image/svg+xml" = gwenview;
      "image/bmp" = gwenview;
      "image/tiff" = gwenview;
      "video/mp4" = haruna;
      "video/x-matroska" = haruna;
      "video/webm" = haruna;
      "video/avi" = haruna;
      "video/quicktime" = haruna;
      "application/zip" = ark;
      "application/x-tar" = ark;
      "application/x-compressed-tar" = ark;
      "application/x-7z-compressed" = ark;
      "application/x-rar" = ark;
      "application/pdf" = "org.pwmt.zathura.desktop";
    };

    # GTK file chooser (open/save dialogs, also behind the GTK portal). Sort column
    # and window geometry are left to the dialog, which rewrites them on every use.
    dconf.settings = let
      chooser = {
        show-hidden = true;
        sort-directories-first = true;
        location-mode = "path-bar";
        date-format = "regular";
      };
    in {
      "org/gtk/settings/file-chooser" = chooser;
      "org/gtk/gtk4/settings/file-chooser" = chooser // {view-type = "list";};
    };
  };
}
