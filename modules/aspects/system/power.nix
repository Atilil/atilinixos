_: {
  den.aspects.power = {
    os = _: {
      powerManagement.enable = true;

      services = {
        tuned = {
          enable = true;
          ppdSupport = true;
          ppdSettings = {
            main = {
              default = "balanced";
              battery_detection = true;
            };
            profiles = {
              power-saver = "powersave";
              balanced = "balanced";
              performance = "throughput-performance";
            };
            battery = {
              power-saver = "laptop-battery-powersave";
              balanced = "balanced-battery";
              performance = "balanced";
            };
          };
        };
        system76-scheduler.settings.cfsProfiles.enable = true;
        upower.enable = true;
        thermald.enable = true;

        acpid = {
          enable = true;
          handlers.power-hibernate = {
            event = "button/power.*";
            action = "systemctl hibernate";
          };
        };
        logind.settings.Login = {
          HandlePowerKey = "ignore";
          HandlePowerKeyLongPress = "poweroff";
          HandleLidSwitch = "suspend-then-hibernate";
          HandleLidSwitchExternalPower = "lock";
          HandleLidSwitchDocked = "ignore";
        };
      };
    };
  };
}
