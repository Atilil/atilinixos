_: {
  den.aspects.hyprland.homeManager = {lib, ...}: {
    wayland.windowManager.hyprland.settings.on._args = [
      "hyprland.start"
      (lib.generators.mkLuaInline ''
        function()
          hl.exec_cmd("vesktop")
          hl.exec_cmd("Telegram")
          hl.exec_cmd("zapzap")
          hl.exec_cmd("thunderbird")
          hl.exec_cmd("kitty --class scratch")
        end
      '')
    ];
  };
}
