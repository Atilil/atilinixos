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
          hl.exec_cmd("uwsm app -- thunderbird")
          hl.exec_cmd("uwsm app -- kitty --class scratch --session ${config.xdg.configHome}/kitty/scratch.kitty-session")
        end
      '')
    ];
  };
}
