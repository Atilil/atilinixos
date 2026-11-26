_: {
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
  };
}
