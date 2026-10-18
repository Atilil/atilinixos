_: {
  den.aspects.hyprland.homeManager = {
    lib,
    pkgs,
    ...
  }: let
    lua = lib.generators.mkLuaInline;
    # Smart scratchpad: (re)spawn the scratch kitty if it was closed, then toggle.
    # The `scratch` window rule sends a new instance to special:scratch silently.
    scratchToggle = pkgs.writeShellScript "scratch-toggle" ''
      if ! hyprctl clients | grep -q "class: scratch$"; then
        kitty --class scratch &
      fi
      hyprctl dispatch 'hl.dsp.workspace.toggle_special("scratch")'
    '';
    cycleTiled = extra:
      lua ''
        function()
          local ws = hl.get_active_workspace()
          local w = hl.get_active_window()
          if ws and w and w.workspace and w.workspace.id == ws.id then
            hl.dispatch(hl.dsp.window.cycle_next({ tiled = true${extra} }))
          end
        end
      '';
    leader = "SUPER";
    dsp = {
      exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
      execTermFloat = cmd: lua ''hl.dsp.exec_cmd("kitty --class center-float ${cmd}")'';
      move = direction: lua ''hl.dsp.window.move({ direction = "${direction}" })'';
      focus = direction: lua ''hl.dsp.focus({ direction = "${direction}" })'';
      workspace = ws: lua ''hl.dsp.focus({ workspace = "${ws}" })'';
      moveTo = ws: lua ''hl.dsp.window.move({ workspace = "${ws}" })'';
      resize = x: y: lua ''hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })'';
      close = lua "hl.dsp.window.close()";
      fullscreen = lua "hl.dsp.window.fullscreen()";
      float = lua "hl.dsp.window.float()";
      # Guarded: Hyprland 0.55.4 segfaults on cycle_next when the focused window is on another workspace.
      cycleNext = cycleTiled "";
      cyclePrev = cycleTiled ", prev = true";
      pin = lua "hl.dsp.window.pin()";
      swap = direction: lua ''hl.dsp.window.swap({ direction = "${direction}" })'';
      drag = lua "hl.dsp.window.drag()";
      resizeFree = lua "hl.dsp.window.resize()";
      quickToggle = lua ''hl.dsp.workspace.toggle_special("quick")'';
      scratchToggle = lua ''hl.dsp.exec_cmd("${scratchToggle}")'';
      swapMaster = lua "hl.dsp.layout('swapwithmaster')";
    };
    bind = keys: dispatcher: {_args = [keys dispatcher];};
    bindOpts = keys: dispatcher: opts: {_args = [keys dispatcher opts];};
  in {
    wayland.windowManager.hyprland.settings = {
      config = {
        input = {
          kb_layout = lib.mkDefault "fr";
          kb_variant = lib.mkDefault "oss";
          kb_options = lib.mkDefault "eurosign:e,caps:escape";
          touchpad.natural_scroll = true;
        };
        binds = {
          workspace_back_and_forth = true;
          workspace_center_on = 1;
          allow_workspace_cycles = true;
          ignore_group_lock = false;
          movefocus_cycles_fullscreen = true;
        };
      };

      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
        {
          fingers = 3;
          direction = "down";
          mods = "ALT";
          action = "close";
        }
        {
          fingers = 3;
          direction = "up";
          action = "fullscreen";
        }
      ];

      bind = [
        # Actions
        (bind "${leader} + Q" dsp.close)
        (bind "${leader} + F" dsp.float)
        (bind "${leader} + SHIFT + F" dsp.fullscreen)
        (bind "${leader} + P" dsp.pin)
        (bind "${leader} + M" dsp.swapMaster)
        (bind "${leader} + code:49" dsp.scratchToggle)
        (bind "${leader} + BackSpace" dsp.scratchToggle) # 2 keys on the Corne (Bsp thumb)
        (bind "ALT + Tab" dsp.cycleNext)
        (bind "SHIFT + ALT + Tab" dsp.cyclePrev)

        # Moves
        (bind "${leader} + SHIFT + H" (dsp.move "left"))
        (bind "${leader} + SHIFT + left" (dsp.move "left"))
        (bind "${leader} + SHIFT + L" (dsp.move "right"))
        (bind "${leader} + SHIFT + right" (dsp.move "right"))
        (bind "${leader} + SHIFT + J" (dsp.move "down"))
        (bind "${leader} + SHIFT + down" (dsp.move "down"))
        (bind "${leader} + SHIFT + K" (dsp.move "up"))
        (bind "${leader} + SHIFT + up" (dsp.move "up"))

        # Navigation
        (bind "${leader} + H" (dsp.focus "left"))
        (bind "${leader} + left" (dsp.focus "left"))
        (bind "${leader} + L" (dsp.focus "right"))
        (bind "${leader} + right" (dsp.focus "right"))
        (bind "${leader} + J" (dsp.focus "down"))
        (bind "${leader} + down" (dsp.focus "down"))
        (bind "${leader} + K" (dsp.focus "up"))
        (bind "${leader} + up" (dsp.focus "up"))

        # Workspaces
        (bind "${leader} + Tab" (dsp.workspace "e+1"))
        (bind "${leader} + SHIFT + Tab" (dsp.workspace "e-1"))
        (bind "${leader} + 1" (dsp.workspace "1"))
        (bind "${leader} + 2" (dsp.workspace "2"))
        (bind "${leader} + 3" (dsp.workspace "3"))
        (bind "${leader} + 4" (dsp.workspace "4"))
        (bind "${leader} + 5" (dsp.workspace "5"))
        (bind "${leader} + 6" (dsp.workspace "6"))
        (bind "${leader} + 7" (dsp.workspace "7"))
        (bind "${leader} + 8" (dsp.workspace "8"))
        (bind "${leader} + 9" (dsp.workspace "9"))
        (bind "${leader} + Escape" dsp.quickToggle)
        (bind "${leader} + SHIFT + 1" (dsp.moveTo "1"))
        (bind "${leader} + SHIFT + 2" (dsp.moveTo "2"))
        (bind "${leader} + SHIFT + 3" (dsp.moveTo "3"))
        (bind "${leader} + SHIFT + 4" (dsp.moveTo "4"))
        (bind "${leader} + SHIFT + 5" (dsp.moveTo "5"))
        (bind "${leader} + SHIFT + 6" (dsp.moveTo "6"))
        (bind "${leader} + SHIFT + 7" (dsp.moveTo "7"))
        (bind "${leader} + SHIFT + 8" (dsp.moveTo "8"))
        (bind "${leader} + SHIFT + 9" (dsp.moveTo "9"))
        (bind "${leader} + SHIFT + Escape" (dsp.moveTo "special:quick"))

        # Applications
        (bind "${leader} + Return" (dsp.exec "kitty"))
        (bind "${leader} + V" (dsp.exec "noctalia msg panel-toggle clipboard"))
        (bind "${leader} + ALT + Delete" (dsp.execTermFloat "btop"))

        # Session
        (bind "${leader} + Delete" (dsp.exec "noctalia msg session lock"))
        (bind "${leader} + SHIFT + Delete" (dsp.exec "noctalia msg panel-toggle session"))

        # Capture
        (bind "${leader} + S" (lua ''hl.dsp.exec_cmd("grim - | satty -f -")''))
        (bind "${leader} + SHIFT + S" (lua ''hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | satty -f -")''))
        (bind "${leader} + SHIFT + R" (lua ''hl.dsp.exec_cmd("wf-recorder -g \"$(slurp)\"")''))

        # Audio
        (bind "XF86AudioRaiseVolume" (dsp.exec "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
        (bind "XF86AudioLowerVolume" (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
        (bind "XF86AudioMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
        (bind "XF86AudioMicMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
        (bind "XF86AudioPlay" (dsp.exec "playerctl play-pause"))
        (bind "XF86AudioNext" (dsp.exec "playerctl next"))
        (bind "XF86AudioPrev" (dsp.exec "playerctl previous"))

        # Brightness
        (bind "XF86MonBrightnessUp" (dsp.exec "brightnessctl set 5%+"))
        (bind "XF86MonBrightnessDown" (dsp.exec "brightnessctl set 5%-"))

        # Resize (repeatable)
        (bindOpts "${leader} + ALT + right" (dsp.resize 50 0) {repeating = true;})
        (bindOpts "${leader} + ALT + L" (dsp.resize 50 0) {repeating = true;})
        (bindOpts "${leader} + ALT + left" (dsp.resize (-50) 0) {repeating = true;})
        (bindOpts "${leader} + ALT + H" (dsp.resize (-50) 0) {repeating = true;})
        (bindOpts "${leader} + ALT + up" (dsp.resize 0 (-50)) {repeating = true;})
        (bindOpts "${leader} + ALT + K" (dsp.resize 0 (-50)) {repeating = true;})
        (bindOpts "${leader} + ALT + down" (dsp.resize 0 50) {repeating = true;})
        (bindOpts "${leader} + ALT + J" (dsp.resize 0 50) {repeating = true;})

        # Numpad
        (bind "${leader} + KP_End" (dsp.workspace "1"))
        (bind "${leader} + KP_Down" (dsp.workspace "2"))
        (bind "${leader} + KP_Next" (dsp.workspace "3"))
        (bind "${leader} + KP_Left" (dsp.workspace "4"))
        (bind "${leader} + KP_Begin" (dsp.workspace "5"))
        (bind "${leader} + KP_Right" (dsp.workspace "6"))
        (bind "${leader} + KP_Home" (dsp.workspace "7"))
        (bind "${leader} + KP_Up" (dsp.workspace "8"))
        (bind "${leader} + KP_Prior" (dsp.workspace "9"))
        (bind "${leader} + SHIFT + KP_End" (dsp.moveTo "1"))
        (bind "${leader} + SHIFT + KP_Down" (dsp.moveTo "2"))
        (bind "${leader} + SHIFT + KP_Next" (dsp.moveTo "3"))
        (bind "${leader} + SHIFT + KP_Left" (dsp.moveTo "4"))
        (bind "${leader} + SHIFT + KP_Begin" (dsp.moveTo "5"))
        (bind "${leader} + SHIFT + KP_Right" (dsp.moveTo "6"))
        (bind "${leader} + SHIFT + KP_Home" (dsp.moveTo "7"))
        (bind "${leader} + SHIFT + KP_Up" (dsp.moveTo "8"))
        (bind "${leader} + SHIFT + KP_Prior" (dsp.moveTo "9"))

        # Swap
        (bind "${leader} + CTRL + H" (dsp.swap "left"))
        (bind "${leader} + CTRL + L" (dsp.swap "right"))
        (bind "${leader} + CTRL + J" (dsp.swap "down"))
        (bind "${leader} + CTRL + K" (dsp.swap "up"))

        # Mouse and drag
        (bindOpts "${leader} + SUPER_L" (dsp.exec "noctalia msg panel-toggle launcher") {release = true;})
        (bind "${leader} + mouse:272" dsp.drag)
        (bind "${leader} + mouse:273" dsp.resizeFree)
      ];
    };
  };
}
