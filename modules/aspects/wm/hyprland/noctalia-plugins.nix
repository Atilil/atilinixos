_: {
  den.aspects.hyprland.homeManager = _: {
    programs.noctalia.settings = {
      plugins = {
        source = [
          {
            name = "official";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            auto_update = true;
          }
          {
            name = "community";
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            auto_update = true;
          }
        ];
        enabled = [
          "avivbintangaringga/nix-monitor"
          "jrohland/claudecode"
          "mdj2812/thunderbird-companion"
          "gcap0n1/f1"
          "asj/task-warrior"
        ];
      };

      plugin_settings = {
        "avivbintangaringga/nix-monitor" = {
          branch = "nixos-26.05";
          # Runs the nightly autoUpgrade now and activates it; reset-failed clears its start limit.
          update_command = "sudo systemctl reset-failed nixos-upgrade; sudo systemctl start nixos-upgrade && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
          clean_command = "nh clean all --keep-one --keep=5 --optimise";
          hide_optimize_button = true;
        };
        "jrohland/claudecode".currency = "eur";
        "noctalia/screen_recorder".video_source = "portal";
      };
    };
  };
}
