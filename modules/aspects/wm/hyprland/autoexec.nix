_: {
  den.aspects.hyprland.homeManager = {
    lib,
    config,
    ...
  }: {
    wayland.windowManager.hyprland.settings.on._args = [
      "hyprland.start"
      (lib.generators.mkLuaInline ''
        function()
          -- --autostart is the only switch that starts Bitwarden hidden in the tray.
          hl.exec_cmd("uwsm app -- bitwarden --autostart")
          hl.exec_cmd("uwsm app -- vesktop")
          hl.exec_cmd("uwsm app -- Telegram")
          hl.exec_cmd("uwsm app -- zapzap")
          -- Thunderbird segfaults if outputs change while it starts (lid check
          -- at 500 ms/3 s in displays.nix, late DisplayLink outputs).
          hl.timer(function() hl.exec_cmd("uwsm app -- thunderbird") end, { timeout = 4000, type = "oneshot" })
          hl.exec_cmd("uwsm app -- kitty --class scratch --session ${config.xdg.configHome}/kitty/scratch.kitty-session")
        end
      '')
    ];
  };
}
