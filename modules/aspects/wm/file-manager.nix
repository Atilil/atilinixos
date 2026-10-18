_: {
  den.aspects.file-manager = {
    os = {pkgs, ...}: {
      services = {
        udisks2.enable = true;
        gvfs.enable = true;
        gnome.sushi.enable = true;
      };
      programs = {
        gnome-disks.enable = true;
        nautilus-open-any-terminal.enable = true;
        nautilus-open-any-terminal.terminal = "kitty";
      };
      environment.systemPackages = with pkgs; [
        nautilus
        loupe
        celluloid
        glib
        ffmpegthumbnailer
        exfatprogs
        ntfs3g
        baobab
        file-roller
        zathura
      ];
      xdg.mime.defaultApplications = {
        "image/png" = "org.gnome.Loupe.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/svg+xml" = "org.gnome.Loupe.desktop";
        "image/bmp" = "org.gnome.Loupe.desktop";
        "image/tiff" = "org.gnome.Loupe.desktop";
        "video/mp4" = "io.github.celluloid_player.Celluloid.desktop";
        "video/x-matroska" = "io.github.celluloid_player.Celluloid.desktop";
        "video/webm" = "io.github.celluloid_player.Celluloid.desktop";
        "video/avi" = "io.github.celluloid_player.Celluloid.desktop";
        "video/quicktime" = "io.github.celluloid_player.Celluloid.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-rar" = "org.gnome.FileRoller.desktop";
        "application/pdf" = "org.gnome.zathura.desktop";
      };
    };
  };
}
