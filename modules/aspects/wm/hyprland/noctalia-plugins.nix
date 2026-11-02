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
          "jrohland/claudecode"
          "mdj2812/thunderbird-companion"
          "gcap0n1/f1"
          "asj/task-warrior"
        ];
      };

      plugin_settings = {
        "jrohland/claudecode".currency = "eur";
        "noctalia/screen_recorder".video_source = "portal";
      };
    };
  };
}
