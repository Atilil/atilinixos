_: {
  den.aspects.core = {
    os = {pkgs, ...}: {
      time.timeZone = "Europe/Paris";
      i18n.defaultLocale = "fr_FR.UTF-8";

      zramSwap.enable = true;

      nix = {
        settings = {
          auto-optimise-store = true;
          experimental-features = ["nix-command" "flakes"];
          download-buffer-size = 1073741824;
          trusted-users = ["root" "@wheel"];
          connect-timeout = 5;
          # Mouse builds every host and serves it (LAN/VPN only); cache.nixos.org covers it being unreachable.
          # Third-party caches belong in mouse's own nix.conf, since it does the building.
          substituters = [
            "http://mouse.macopla.home:5000?priority=5"
            "https://cache.nixos.org?priority=10"
          ];
          trusted-public-keys = [
            "mouse.macopla.home-1:/nNMhAXPsgpIZKEBkg4IqGM8nJArW/RLKD+kShiUnvM="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
        };
        extraOptions = "warn-dirty = false";
        gc = {
          automatic = true;
          dates = "weekly";
          persistent = true;
        };
      };

      boot.kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "fs.inotify.max_user_instances" = 512;
      };

      programs = {
        nix-ld.enable = true;
        appimage.enable = true;
      };

      networking.networkmanager = {
        enable = true;
        wifi.powersave = true;
      };

      # Pulls main, already built by CI and served by Harmonia: nothing compiles here.
      system.autoUpgrade = {
        enable = true;
        flake = "git+ssh://git@forge.macopla.com:2222/yoann/NixOS.git?ref=main";
        # The module already adds --refresh and --flake.
        flags = ["--print-build-logs"];
        operation = "boot";
        # Channels only: with a flake it just logs a warning.
        upgrade = false;
        dates = "daily";
        randomizedDelaySec = "45min";
        runGarbageCollection = true;
      };

      systemd.services.nixos-upgrade = {
        serviceConfig = {
          Nice = 19;
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
          # Retry a transient failure (network, forge) a few times, then give up until the next timer.
          Restart = "on-failure";
          RestartSec = "10min";
        };
        unitConfig = {
          StartLimitIntervalSec = "3h";
          StartLimitBurst = 3;
          # Merges with the module's own OnSuccess (nix-gc.service), both run after a success.
          OnSuccess = ["nixos-upgrade-notify.service"];
        };
      };

      # Tells graphical users a new system waits for a reboot, once per pending generation.
      systemd.services.nixos-upgrade-notify = {
        description = "Notify users of a pending NixOS generation";
        serviceConfig = {
          Type = "oneshot";
          StateDirectory = "nixos-upgrade-notify";
        };
        path = [pkgs.coreutils pkgs.systemd pkgs.util-linux pkgs.libnotify];
        script = ''
          state=/var/lib/nixos-upgrade-notify/last
          new=$(readlink -f /nix/var/nix/profiles/system)
          [ "$new" = "$(readlink -f /run/booted-system)" ] && exit 0
          [ "$new" = "$(cat "$state" 2>/dev/null)" ] && exit 0
          users=$(loginctl list-sessions --no-legend | while read -r id _; do
            type=$(loginctl show-session "$id" -p Type --value)
            case "$type" in wayland | x11) ;; *) continue ;; esac
            echo "$(loginctl show-session "$id" -p User --value) $(loginctl show-session "$id" -p Name --value)"
          done | sort -u)
          sent=0
          while read -r uid name; do
            # Real users only: the greeter also runs a graphical session under a system account.
            [ -n "$uid" ] && [ "$uid" -ge 1000 ] || continue
            # runuser plus the user bus path needs no polkit and no user manager lookup.
            if runuser -u "$name" -- env "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus" \
              notify-send -a NixOS "Mise à jour installée" "Elle sera appliquée au prochain redémarrage."; then
              sent=1
            fi
          done <<< "$users"
          # Unannounced until someone actually saw it: the next daily run retries.
          if [ "$sent" = 1 ]; then echo "$new" > "$state"; fi
        '';
      };

      # Read-only deploy key for the private forge repo; root only, since IdentityFile adds up for every user.
      programs.ssh = {
        extraConfig = ''
          Match host forge.macopla.com localuser root
            Port 2222
            User git
            IdentityFile /run/secrets/forge_deploy_key
            IdentitiesOnly yes
        '';
        knownHosts."[forge.macopla.com]:2222".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7DDIdXCZWxxLpkxdmJrN1ZmX0JQGUz5vm17eHOAH4QQyrl4UYikoKq+OEVz9Fy4ihJhptnnbr41yRLMWAGdh1+YFyTp5op4pcbWR15TaI0i+U0xG0R441B6J1hEaaoyCfBvG4jcUXlUHVarNLSseeZt0UfwIK1ZP7iynLWLeaep3uCbFmJ4aHqWW/V1X8VSe5SMz2wFK0pcje65hR8IS7w/ltaxA/9bJCyC+82Z5ZxggUzJtsi2ndlPQbzH5/JKtEr8mkKMuHYEi3lqK/3KGzaUgVSOP5f7PtBS/zAoM0M4iXThYdYuYW2xKIum/inYaOTxE3lOH2bZwTNcsk2d8V4UsvwytJoZUVN4Vy75Es34D1mSCU4aU3mPnTCw0086nyyeAe7703Bivg5LUau5vLgtYuZRqJ1xEC4rI2DJmjKEpT1v45svpUr2lFAI5yBGqsQbW51IAVspMrZjD3KaqRrY1gjw3HyD7NHyShRnoWZLvhtJihxzQ6d7++idD+KaS2+ibQOAR67qtDi0RRctUkeL7UqNyv17uLIoE3dNWsJj3UMa64ElWwV5e25W0J/9M+SCK629kDwbrVYUAPe0St6bezdXc/wVE+lUhAZ+IBB0pJABG77mTC1OO03hNPSH6aPZRR5kyTboItkhkdEeljZGNw4m5PA9C3HfFW1H9v8w==";
      };
    };
  };
}
