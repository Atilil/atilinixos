_: {
  den.aspects.hyprland.homeManager = _: {
    wayland.windowManager.hyprland.settings.workspace_rule = [
      # Bottom ultrawide (main): 1-3
      {
        workspace = "1";
        layout = "master";
        monitor = "desc:LG Electronics 38GN950 307NTDV46930";
        default = true;
        persistent = true;
      }
      {
        workspace = "2";
        monitor = "desc:LG Electronics 38GN950 307NTDV46930";
        persistent = true;
      }
      {
        workspace = "3";
        monitor = "desc:LG Electronics 38GN950 307NTDV46930";
        persistent = true;
      }

      # Top ultrawide (secondary): 4-6
      {
        workspace = "4";
        monitor = "desc:LG Electronics 38GL950G 0x01010101";
        default = true;
        persistent = true;
      }
      {
        workspace = "5";
        monitor = "desc:LG Electronics 38GL950G 0x01010101";
        persistent = true;
      }
      {
        workspace = "6";
        monitor = "desc:LG Electronics 38GL950G 0x01010101";
        persistent = true;
      }

      # Laptop: 7-9
      {
        workspace = "7";
        monitor = "desc:LG Display 0x06E0";
        default = true;
        persistent = true;
      }
      {
        workspace = "8";
        monitor = "desc:LG Display 0x06E0";
        persistent = true;
      }
      {
        workspace = "9";
        layout = "monocle";
        monitor = "desc:LG Display 0x06E0";
        persistent = true;
      }

      # Ultrawide Daniel
      # {
      #   workspace = "1";
      #   monitor = "desc:Samsung Electric Company C49HG9x H4ZMC00740";
      #   persistent = true;
      # }
      # {
      #   workspace = "2";
      #   monitor = "desc:Samsung Electric Company C49HG9x H4ZMC00740";
      #   persistent = true;
      # }
      # {
      #   workspace = "3";
      #   monitor = "desc:Samsung Electric Company C49HG9x H4ZMC00740";
      #   persistent = true;
      # }
      # {
      #   workspace = "4";
      #   monitor = "desc:Samsung Electric Company C49HG9x H4ZMC00740";
      #   persistent = true;
      # }
      # {
      #   workspace = "5";
      #   monitor = "desc:Samsung Electric Company C49HG9x H4ZMC00740";
      #   persistent = true;
      # }
      # {
      #   workspace = "6";
      #   monitor = "desc:Samsung Electric Company C49HG9x H4ZMC00740";
      #   persistent = true;
      # }
    ];
  };
}
