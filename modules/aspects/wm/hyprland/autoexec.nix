_: {
  den.aspects.hyprland.homeManager = {lib, ...}: {
    wayland.windowManager.hyprland.settings.on._args = [
      "hyprland.start"
      (lib.generators.mkLuaInline ''
        function()
          hl.exec_cmd("uwsm app -- vesktop")
          hl.exec_cmd("uwsm app -- Telegram")
          hl.exec_cmd("uwsm app -- zapzap")
          hl.exec_cmd("uwsm app -- thunderbird")
          hl.exec_cmd("uwsm app -- kitty --class scratch")
        end
      '')
    ];
  };
}
