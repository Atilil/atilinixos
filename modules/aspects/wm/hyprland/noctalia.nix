_: {
  flake-file.inputs.noctalia.url = "github:noctalia-dev/noctalia/cachix";
  den.aspects.hyprland.homeManager = {config, ...}: let
    home = config.home.homeDirectory;
  in {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      # Base layer only: ~/.local/state/noctalia/settings.toml (GUI) still
      # overrides it. Palette, wallpapers and widget positions stay GUI-managed.
      settings = {
        shell = {
          # Noctalia is the session polkit agent (themed prompts); no other agent
          # must run, or registration fails.
          polkit_agent = true;
          # Own cgroup per app, so restarting Noctalia does not kill them
          launch_apps_as_systemd_services = true;
          telemetry_enabled = false;
          external_ip_enabled = true;
          font_family = "DejaVu Sans";
          corner_radius_scale = 1.4;
          password_style = "random";

          greeter_sync.auto_sync = true;
          launcher = {
            compact = true;
            show_app_actions = true;
          };
          panel = {
            open_near_click_clipboard = true;
            open_near_click_control_center = true;
            open_near_click_session = true;
            open_near_click_wallpaper = true;
            transparency_mode = "glass";
          };
          screen_corners = {
            enabled = true;
            size = 18;
          };
          screenshot = {
            annotate = true;
            directory = "${home}/Pictures/Screenshots";
            skip_annotate_on_copy_save = true;
          };
        };

        # Which apps Noctalia themes; each needs its own wiring (see btop.nix,
        # messaging.nix, theme.nix). The palette itself is picked in the GUI.
        theme.templates = {
          builtin_ids = ["btop" "gtk3" "gtk4" "hyprland" "kitty" "qt" "starship"];
          community_ids = ["zen-browser" "telegram" "neovim" "zed" "steam" "thunderbird" "hyprtoolkit" "yazi"];
        };

        idle = {
          behavior_order = ["lock" "screen-off" "lock-and-suspend"];
          behavior = {
            lock = {
              action = "lock";
              enabled = true;
              timeout = 600;
            };
            screen-off = {
              action = "screen_off";
              enabled = true;
              timeout = 660;
            };
            lock-and-suspend = {
              action = "lock_and_suspend";
              enabled = true;
              timeout = 900;
            };
          };
        };

        audio.enable_overdrive = true;
        battery.warning_threshold = 15;
        brightness = {
          minimum_brightness = 0.11;
          sync_all_monitors = true;
        };
        control_center.sidebar_section = "none";
        location.address = "LEOGNAN, France";
        calendar.account.perso_google = {
          name = "Calendrier personnel";
          type = "google";
        };
        wallpaper.directory = "${home}/Pictures/wallpapers";
      };
    };
  };
}
