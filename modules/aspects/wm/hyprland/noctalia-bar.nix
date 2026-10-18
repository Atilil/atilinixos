_: {
  den.aspects.hyprland.homeManager = _: {
    programs.noctalia.settings = {
      bar = {
        order = ["default"];
        default = {
          background_opacity = 0.62;
          color = "primary";
          font_weight = 700;
          start = ["power_profile" "nix-monitor" "status_2" "cpu" "sysmon" "network_rx" "network_tx" "temp"];
          center = ["mail" "screenshot" "workspaces" "clipboard" "notifications"];
          end = ["pill" "bar_2" "tray" "network" "bluetooth" "volume" "brightness" "battery" "clock" "session"];
        };
      };

      # Per-widget options; plugin widgets are instances named here and placed above
      widget = {
        # Plugin widgets
        nix-monitor = {
          type = "avivbintangaringga/nix-monitor:nix-monitor";
          colorize_glyph = false;
          show_text = false;
        };
        status_2.type = "mindnbytes/nix-status:status";
        mail = {
          type = "mdj2812/thunderbird-companion:mail";
          scale = 1.3;
        };
        pill.type = "jrohland/claudecode:pill";
        bar_2.type = "gcap0n1/f1:bar";

        # Built-in widgets
        power_profile.scale = 1.2;
        sysmon.stat = "ram_pct";
        screenshot.scale = 1.55;
        workspaces = {
          anchor = true;
          empty_color = "tertiary";
          scale = 1.25;
        };
        tray.drawer = true;
        network.show_label = false;
        battery = {
          display_mode = "graphic";
          hide_when_full = true;
          show_label = false;
        };
        media = {
          hide_when_no_media = true;
          title_scroll = "always";
        };
      };
    };
  };
}
