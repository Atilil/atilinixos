_: {
  den.aspects.shell = {
    homeManager = _: {
      programs = {
        fastfetch = {
          enable = true;
          settings = {
            display.separator = " ";
            modules = [
              "break"
              {
                type = "custom";
                format = "┌────────────────Hardware────────────────┐";
                outputColor = "cyan";
              }
              {
                type = "host";
                key = "│ ├ PC ";
                keyColor = "red";
              }
              {
                type = "cpu";
                key = "│ ├ ";
                keyColor = "red";
              }
              {
                type = "gpu";
                key = "│ ├󰒆 ";
                keyColor = "red";
              }
              {
                type = "disk";
                key = "│ ├";
                folders = "/";
                format = "{size-used} / {size-total} ({size-percentage})";
                keyColor = "red";
              }
              {
                type = "swap";
                key = "│ ├󰯎";
                keyColor = "red";
              }
              {
                type = "display";
                key = "│ ├󰍹 ";
                keyColor = "red";
                format = "MONITOR ({name})";
              }
              {
                type = "memory";
                key = "└ └󰍛 ";
                keyColor = "red";
              }
              {
                type = "custom";
                format = "└────────────────────────────────────────┘";
                outputColor = "cyan";
              }
              {
                type = "custom";
                format = "┌────────────────Software────────────────┐";
                outputColor = "cyan";
              }
              {
                type = "os";
                key = "│ ├󱄅 OS ";
                keyColor = "green";
              }
              {
                type = "kernel";
                key = "│ ├ ";
                keyColor = "green";
              }
              {
                type = "packages";
                key = "│ ├󰏖 ";
                keyColor = "green";
              }
              {
                type = "localip";
                key = "│ ├󰩟";
                keyColor = "green";
              }
              {
                type = "shell";
                key = "└ └ ";
                keyColor = "green";
              }
              {
                type = "lm";
                key = "│ ├ ";
                keyColor = "blue";
              }
              {
                type = "wm";
                key = "│ ├ ";
                keyColor = "blue";
              }
              {
                type = "terminal";
                key = "│ ├ ";
                keyColor = "blue";
              }
              {
                type = "terminalfont";
                key = "└ └ ";
                keyColor = "blue";
              }
              {
                type = "custom";
                format = "└────────────────────────────────────────┘";
                outputColor = "cyan";
              }
              {
                type = "custom";
                format = "┌─────────────────Uptime─────────────────┐";
                outputColor = "cyan";
              }
              {
                type = "uptime";
                key = "  Uptime";
                keyColor = "magenta";
              }
              {
                type = "custom";
                format = "└────────────────────────────────────────┘";
                outputColor = "cyan";
              }
              # ANSI palette bar, tracks kitty's live Noctalia colors
              {
                type = "colors";
                symbol = "circle";
                paddingLeft = 2;
              }
            ];
          };
        };
      };
    };
  };
}
