{inputs, ...}: {
  # Noctalia greeter (greetd). `follows` keeps glibc/libglvnd identical to the
  # host so the greeter loads the system mesa drivers without ABI mismatch; the
  # package is small, so the lost upstream binary cache costs one local build.
  flake-file.inputs.noctalia-greeter = {
    url = "github:noctalia-dev/noctalia-greeter/v1.6.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.greeter = {
    os = {
      config,
      pkgs,
      lib,
      ...
    }: let
      xkb = config.services.xserver.xkb;
    in {
      # The greeter user needs the Nordzy cursor installed system-wide (laptop only).
      # Kept here, not in the host part, to preserve systemPackages merge order.
      environment.systemPackages = lib.optional ((config.services.displayManager.noctalia-greeter.settings.cursor.theme or "") == "Nordzy-cursors") pkgs.nordzy-cursor-theme;

      # The flake module only: nixpkgs 26.05 ships no noctalia-greeter module.
      imports = [inputs.noctalia-greeter.nixosModules.default];

      services.displayManager.noctalia-greeter = {
        enable = true;

        settings = {
          # Reuse the system XKB layout from the clavier aspect.
          keyboard = {
            layout = xkb.layout;
            variant = xkb.variant;
            options = xkb.options;
            numlock = true;
          };
        };
      };
    };
  };

  # Per-host greeter parts.
  den.aspects.laptop.includes = [
    {
      os = {
        pkgs,
        lib,
        config,
        ...
      }: let
        cfg = config.services.displayManager.noctalia-greeter;
        # Stable, colon-free alias for the Intel iGPU (see the udev rule below).
        igpu = "/dev/dri/igpu-card";
      in {
        services.displayManager.noctalia-greeter = {
          # Let yoann push the Noctalia wallpaper/palette/font to the greeter
          # (sync.toml) through polkit without a password prompt.
          passwordless-sync-users = ["yoann"];

          settings = {
            # Default to the UWSM session; name as listed by `noctalia-greeter sessions`.
            session.default = "Hyprland (uwsm-managed)";

            # No "last user" memory in the greeter: open on yoann's password
            # step; Esc returns to the user list for audrey.
            user.default = "yoann";

            # Pin the greeter to the LG at its native 21:9 mode (the dock advertises 3840x2160 first).
            # Without DP-1 the compositor uses every output it sees: only the laptop panel, thanks to
            # WLR_DRM_DEVICES below. Outputs lacking this mode (eDP-1) use their preferred one.
            output = {
              name = "DP-1";
              width = 3840;
              height = 1600;
            };

            # Same cursor as the Hyprland session (home.pointerCursor), found
            # via the system-wide icon path rather than the user's home.
            cursor = {
              theme = "Nordzy-cursors";
              size = 32;
              path = "${pkgs.nordzy-cursor-theme}/share/icons";
            };
          };
        };

        # Restrict the greeter compositor to the Intel iGPU: the late-appearing DisplayLink evdi device
        # causes the dlm boot race and the multi-GPU black screen (issue #59).
        # Mirrors the module's default command, adding only the env assignment.
        services.greetd.settings.default_session.command = "${lib.getExe' pkgs.coreutils "env"} WLR_DRM_DEVICES=${igpu} XDG_DATA_DIRS=${config.services.displayManager.sessionData.desktops}/share ${cfg.package}/bin/noctalia-greeter-session -- ${cfg.greeter-args}";

        # wlroots splits WLR_DRM_DEVICES on ':' without escaping, so the by-path links (pci-0000:00:02.0)
        # cannot be used: alias keyed on the i915 driver instead of the volatile cardN.
        # mkBefore keeps this rule ahead of the other udev rules.
        services.udev.extraRules = lib.mkBefore ''
          SUBSYSTEM=="drm", KERNEL=="card[0-9]*", SUBSYSTEMS=="pci", DRIVERS=="i915", SYMLINK+="dri/igpu-card"
        '';

        # Password-only login: pam_fprintd is `sufficient` and runs before
        # pam_gnome_keyring, so a fingerprint login leaves the keyring locked
        # (no password to decrypt it). Fingerprint stays for sudo and lock screen.
        security.pam.services.greetd.fprintAuth = false;
        # Unlock KWallet at login for audrey's Plasma session (no-op under Hyprland).
        security.pam.services.greetd.kwallet.enable = true;
      };
    }
  ];

  den.aspects.ideapad.includes = [
    {
      os = {
        config,
        pkgs,
        ...
      }: let
        breeze = pkgs.kdePackages.breeze;
        # Follow maria's Plasma colours: dark greeter when her scheme is Breeze Dark.
        dark = config.home-manager.users.maria.programs.plasma.workspace.colorScheme == "BreezeDark";
        # Breeze colour schemes (BreezeLight/BreezeDark.colors) mapped onto the greeter's palette.
        common = {
          primary = "#3daee9";
          on_primary = "#ffffff";
          tertiary = "#27ae60";
          on_tertiary = "#ffffff";
          error = "#da4453";
          on_error = "#ffffff";
          shadow = "#000000";
          hover = "#3daee9";
          on_hover = "#ffffff";
        };
        palette =
          common
          // (
            if dark
            then {
              secondary = "#1d99f3";
              on_secondary = "#ffffff";
              surface = "#202326";
              on_surface = "#fcfcfc";
              surface_variant = "#292c30";
              on_surface_variant = "#a1a9b1";
              outline = "#4d4d4d";
            }
            else {
              secondary = "#2980b9";
              on_secondary = "#ffffff";
              surface = "#eff0f1";
              on_surface = "#232629";
              surface_variant = "#e3e5e7";
              on_surface_variant = "#707d8a";
              outline = "#bdc3c7";
            }
          );
      in {
        # Patched greeter (ideapad only): hides the session selector, which v1.6.0 cannot
        # do by option (_greeter/ideapad.patch). Re-check when bumping the input.
        services.displayManager.noctalia-greeter.package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
          patches = (old.patches or []) ++ [./_greeter/ideapad.patch];
        });

        # Unlock KWallet at login (plasma6 only wires `login`); needs identical passwords.
        security.pam.services.greetd.kwallet.enable = true;

        services.displayManager.noctalia-greeter.settings = {
          # Name as listed by `noctalia-greeter sessions`.
          session.default = "Plasma (Wayland)";
          user.default = "maria";

          appearance = {
            scheme = "Synced"; # use the palette below
            theme_mode =
              if dark
              then "dark"
              else "light";
            hide_logo = true; # no Noctalia branding for Maria
            scheme_selector_position = "hidden"; # no scheme picker either
            # Same family as Maria's Plasma fonts.
            font_family = "Noto Sans";
            inherit palette;
            # Breeze "Next" wallpaper, light or dark variant like Plasma.
            wallpaper = {
              path = "${breeze}/share/wallpapers/Next/contents/${
                if dark
                then "images_dark"
                else "images"
              }/5120x2880.png";
              fill_mode = "crop";
            };
          };

          # Same Breeze cursor as her Plasma session.
          cursor = {
            theme = "breeze_cursors";
            size = 24;
            path = "${breeze}/share/icons";
          };
        };
      };
    }
  ];
}
