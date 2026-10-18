{den, ...}: {
  den.aspects.ideapad = {
    includes = with den; [
      batteries.hostname
      aspects.core
      aspects.security
      aspects.audio
      aspects.bluetooth
      aspects.power
      aspects.clavier
      aspects.greeter
      aspects.plasma
      aspects.remote-access
      aspects.vpn
    ];

    os = {
      config,
      pkgs,
      lib,
      ...
    }: let
      # maria's folders living on the HDD (bind-mounted below).
      dataDirs = ["Desktop" "Documents" "Downloads" "Music" "Pictures" "Videos"];
    in {
      imports = [./_hardware.nix];

      boot.loader = {
        systemd-boot = {
          enable = true;
          editor = false;
          configurationLimit = 5;
        };
        efi.canTouchEfiVariables = true;
      };

      # 1 TB HDD (WDC WD10SPZX): maria's data. The SSD keeps /, the store and home.
      fileSystems =
        {
          "/data" = {
            device = "/dev/disk/by-label/data";
            # btrfs for snapshots; @data subvolume so they can live beside it.
            fsType = "btrfs";
            options = ["subvol=@data" "noatime" "nofail"]; # a dead HDD must not block boot
          };
        }
        // lib.genAttrs (map (d: "/home/maria/${d}") dataDirs) (target: {
          device = "/data/maria/${baseNameOf target}";
          fsType = "none";
          options = ["bind" "nofail"];
          depends = ["/data"];
        });
      systemd.tmpfiles.rules =
        ["d /data/maria 0700 maria users -"]
        ++ map (d: "d /data/maria/${d} 0755 maria users -") dataDirs;

      # Snapshots of /data against accidental deletion (not a backup: same disk).
      # Restore as root: snapper -c data list; cp -a /data/.snapshots/<n>/snapshot/maria/... /data/maria/...
      services.snapper.configs.data = {
        SUBVOLUME = "/data";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 24;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 6;
        TIMELINE_LIMIT_YEARLY = 0;
      };

      networking.firewall.enable = true;

      # Beginner user: no Discover (software changes go through the admin's config).
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        discover
        kwin-x11 # no X11 session (see the plasma aspect)
        kate
        ktexteditor # kate's elevated actions only
        khelpcenter
        plasma-keyboard # no touch keyboard on this laptop
        qtvirtualkeyboard # plasma-keyboard's KCM only
        qrca # QR scanner, pulled in by NetworkManager
        elisa # per-user, via the elisa aspect
      ];

      # No NixOS manual launcher in the menu.
      documentation.nixos.enable = false;

      # Hide tuned's GUI launcher (no option: strip its .desktop file).
      services.tuned.package = pkgs.tuned.overrideAttrs (old: {
        postFixup =
          (old.postFixup or "")
          + ''
            rm -f $out/share/applications/tuned-gui.desktop
          '';
      });

      # Explicit: 8 GB RAM relies on zram.
      zramSwap.enable = true;

      # Lets maria change her password; root has no password (SSH key only).
      users.mutableUsers = true;

      # Read at account creation only (mutableUsers), so it must match KWallet's password.
      # The sops module and the host age key come from the vpn aspect.
      sops.secrets.maria_password = {
        sopsFile = ./sops/secrets.yaml;
        neededForUsers = true;
      };
      # `or null`: the VM variant drops every sops secret.
      users.users.maria.hashedPasswordFile = config.sops.secrets.maria_password.path or null;

      virtualisation.vmVariant = {
        # VM: enough resources for Plasma.
        virtualisation = {
          memorySize = 4096;
          cores = 4;
        };
        # The VM has no sops key.
        users.users.maria.initialPassword = "maria";
      };
    };
  };
}
