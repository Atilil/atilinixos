{
  config,
  lib,
  utils,
  ...
}: let
  # Media shares maintained from the laptop (rename, cleanup). The Jellyfin
  # server mounts the same exports read-only because it is internet-exposed;
  # write access is only granted here, on the admin machine.
  nfsShares = {
    "/mnt/jellyfin" = "10.86.30.100:/mnt/tank/jellyfin";
    "/mnt/NAS-EXT/ATN" = "192.168.1.192:/volume1/Plex";
    "/mnt/NAS-EXT/NAS3" = "192.168.30.68:/volume1/video";
    "/mnt/NAS-EXT/DS918D" = "192.168.30.20:/volume1/video";
    "/mnt/NAS-EXT/NAS1" = "192.168.30.239:/volume3/GuiTemp";
  };

  # DSM enforces ACLs per DSM account, which NFS (uid-based) cannot satisfy,
  # so this Synology is mounted over SMB with a dedicated account.
  smbShares = {
    "/mnt/NAS-EXT/16T" = "//192.168.70.200/16T";
    "/mnt/NAS-EXT/4K" = "//192.168.70.200/4K";
    "/mnt/NAS-EXT/DX1" = "//192.168.70.200/DX-1";
    "/mnt/NAS-EXT/DX2" = "//192.168.70.200/DX-2";
    "/mnt/NAS-EXT/DX4" = "//192.168.70.200/DX-4";
  };

  # The laptop is often off the LAN/VPN: nothing may block boot, suspend or
  # the desktop. Automount mounts lazily on first access and unmounts when
  # idle; softerr + short timeo/retrans make an unreachable NAS return an
  # error (ETIMEDOUT) instead of hanging processes forever.
  commonOptions = [
    "rw"
    "noatime"
    "noauto"
    "nofail"
    "_netdev"
    "x-systemd.automount"
    "x-systemd.idle-timeout=600"
    "x-systemd.mount-timeout=15"
  ];
  nfsOptions =
    commonOptions
    ++ [
      "softerr"
      "timeo=50"
      "retrans=2"
    ];
  # uid/gid by name: the user's uid is auto-allocated, not pinned in the config.
  smbOptions =
    commonOptions
    ++ [
      "credentials=${config.sops.secrets.nas_ext_smb_credentials.path}"
      "uid=yoann"
      "gid=users"
      "file_mode=0664"
      "dir_mode=0775"
      "soft"
      "echo_interval=10"
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
      options = nfsOptions;
    })
    nfsShares
    // lib.mapAttrs (_: device: {
      inherit device;
      fsType = "cifs";
      options = smbOptions;
    })
    smbShares;

  # Client userland: mount.nfs, idmapd, rpcbind and mount.cifs (cifs-utils).
  boot.supportedFilesystems = ["nfs" "cifs"];

  # Failed automounts (NAS unreachable) would hit the default start limit and
  # stay dead until `systemctl reset-failed`. asDropin leaves the
  # fstab-generated unit in place instead of shadowing it with a full unit.
  systemd.units =
    lib.mapAttrs' (
      mountpoint: _:
        lib.nameValuePair "${utils.escapeSystemdPath mountpoint}.mount" {
          overrideStrategy = "asDropin";
          text = ''
            [Unit]
            StartLimitIntervalSec=0
          '';
        }
    )
    (nfsShares // smbShares);

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
}
