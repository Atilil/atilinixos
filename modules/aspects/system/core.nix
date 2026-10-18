_: {
  den.aspects.core = {
    os = {flakePath, ...}: {
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
          substituters = [
            # Harmonia on mouse, LAN/VPN only, asked first so builder paths come over the LAN
            "http://mouse.macopla.home:5000?priority=5"
            "https://cache.nixos.org?priority=10"
            "https://nix-community.cachix.org"
            "https://hyprland.cachix.org"
          ];
          extra-substituters = ["https://noctalia.cachix.org"];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
          trusted-substituters = ["https://hyprland.cachix.org"];
          trusted-public-keys = [
            "mouse.macopla.home-1:/nNMhAXPsgpIZKEBkg4IqGM8nJArW/RLKD+kShiUnvM="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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

      system.autoUpgrade = {
        enable = true;
        flake = flakePath;
        flags = ["--print-build-logs" "--commit-lock-file"];
        dates = "weekly";
        randomizedDelaySec = "45min";
        runGarbageCollection = true;
      };
      programs.git.config = {
        safe.directory = [flakePath];
        user = {
          name = "NixOS AutoUpgrade";
          email = "root@localhost";
        };
      };
    };
  };
}
