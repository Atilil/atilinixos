_: {
  # Docked: the laptop panel follows the lid. Only eDP-1 is toggled: disabling
  # an LG cuts both outputs of the DisplayLink dock.
  den.aspects.hyprland.homeManager = _: {
    wayland.windowManager.hyprland.extraConfig = ''
      local edpDesc = "LG Display 0x06E0"
      local edp = "desc:" .. edpDesc

      -- With no output left Hyprland adds a headless "FALLBACK" monitor to
      -- hl.get_monitors(); it is not a screen.
      local function realMonitors()
        local list = {}
        for _, m in ipairs(hl.get_monitors()) do
          if m.name ~= "FALLBACK" then list[#list + 1] = m end
        end
        return list
      end

      local function externalPresent()
        for _, m in ipairs(realMonitors()) do
          if m.description ~= edpDesc then return true end
        end
        return false
      end

      local function lidClosed()
        local f = io.open("/proc/acpi/button/lid/LID0/state")
        if not f then return false end
        local state = f:read("*a")
        f:close()
        return state:find("closed") ~= nil
      end

      -- Never leave the session without a screen: only with an external one.
      local function edpOff()
        if externalPresent() then hl.monitor({ output = edp, disabled = true }) end
      end

      -- Without any real output the monitor-rule reload is never applied (it
      -- waits for a frame, which the fallback output cannot render); a config
      -- reload re-enables eDP-1 synchronously from the static rule.
      local function edpOn()
        if #realMonitors() == 0 then
          hl.dispatch(hl.dsp.exec_cmd("hyprctl reload"))
        else
          hl.monitor({ output = edp, disabled = false })
        end
      end

      -- Undocking with the lid closed removes the last output.
      hl.on("monitor.removed", function()
        if #realMonitors() == 0 then edpOn() end
      end)

      -- locked: must fire while Noctalia's lock screen is up.
      hl.bind("switch:on:Lid Switch", edpOff, { locked = true })
      hl.bind("switch:off:Lid Switch", edpOn, { locked = true })

      -- Start with the lid already closed. The retry covers a dock whose
      -- outputs show up after the session starts.
      hl.on("hyprland.start", function()
        local function check() if lidClosed() then edpOff() end end
        check()
        hl.timer(check, { timeout = 3000, type = "oneshot" })
      end)
    '';
  };
}
