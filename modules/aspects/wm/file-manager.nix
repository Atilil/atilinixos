_: {
  # Host plumbing only: mounting, trash, filesystems, thumbnails. Apps and file
  # associations are per user (desktop-apps aspect, Plasma defaults for KDE users).
  den.aspects.file-manager = {
    os = {pkgs, ...}: {
      services = {
        udisks2.enable = true;
        gvfs.enable = true;
      };
      programs.gnome-disks.enable = true;
      environment.systemPackages = with pkgs; [
        glib
        ffmpegthumbnailer
        exfatprogs
        ntfs3g
      ];
    };
  };
}
