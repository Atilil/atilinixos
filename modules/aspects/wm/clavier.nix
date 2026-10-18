_: {
  # XKB on; the layout is per host, below.
  den.aspects.clavier = {
    os = _: {
      services.xserver.enable = true;
    };
  };

  # Per-host layouts.
  den.aspects.laptop.includes = [
    {
      os = _: {
        services.xserver.xkb = {
          layout = "us,fr";
          variant = "intl,oss";
          options = "grp:win_space_toggle,eurosign:e,caps:escape";
        };
      };
    }
  ];

  den.aspects.ideapad.includes = [
    {
      os = _: {
        services.xserver.xkb.layout = "fr";
      };
    }
  ];
}
