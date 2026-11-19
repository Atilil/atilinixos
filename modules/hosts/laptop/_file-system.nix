{lib, ...}: let
  # Media shares maintained from the laptop (rename, cleanup). The Jellyfin
  # server mounts the same exports read-only because it is internet-exposed;
  # write access is only granted here, on the admin machine.
  nasShares = {
    "/mnt/jellyfin" = "10.86.30.100:/mnt/tank/jellyfin";
    "/mnt/NAS-EXT/16T" = "192.168.70.200:/volume3/16T";
    "/mnt/NAS-EXT/4K" = "192.168.70.200:/volume2/4K";
    "/mnt/NAS-EXT/DX1" = "192.168.70.200:/volume4/DX-1";
    "/mnt/NAS-EXT/DX2" = "192.168.70.200:/volume5/DX-2";
    "/mnt/NAS-EXT/DX4" = "192.168.70.200:/volume7/DX-4";
    "/mnt/NAS-EXT/ATN" = "192.168.1.192:/volume1/Plex";
    "/mnt/NAS-EXT/NAS3" = "192.168.30.68:/volume1/video";
    "/mnt/NAS-EXT/DS918D" = "192.168.30.20:/volume1/video";
    "/mnt/NAS-EXT/NAS1" = "192.168.30.239:/volume3/GuiTemp";
  };

  # The laptop is often off the LAN/VPN: nothing may block boot, suspend or
  # the desktop. Automount mounts lazily on first access and unmounts when
  # idle; softerr + short timeo/retrans make an unreachable NAS return an
  # error (ETIMEDOUT) instead of hanging processes forever.
  nasMountOptions = [
    "rw"
    "noatime"
    "noauto"
    "nofail"
    "_netdev"
    "softerr"
    "timeo=50"
    "retrans=2"
    "x-systemd.automount"
    "x-systemd.idle-timeout=600"
    "x-systemd.mount-timeout=15"
  ];
in {
  fileSystems =
    {
      "/" = {
        device = "/dev/disk/by-label/NIXROOT";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-label/NIXBOOT";
        fsType = "vfat";
      };
    }
    // lib.mapAttrs (_: device: {
      inherit device;
      fsType = "nfs4";
      options = nasMountOptions;
    })
    nasShares;

  # NFS client userland (mount.nfs, idmapd, rpcbind) for the mounts above.
  boot.supportedFilesystems = ["nfs"];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
}
