{den, ...}: {
  den.aspects.hyprland = {
    includes = [
      den.aspects.desktop-theme
      den.aspects.luciole
      den.aspects.noctalia
    ];

    os = {pkgs, ...}: {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };

      environment.systemPackages = with pkgs; [qt5.qtwayland qt6.qtwayland];

      # KDE Connect (Valent) ports
      networking.firewall = {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
      };
    };

    homeManager = {
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        package = null;
        portalPackage = null;
        systemd.enable = false;
      };
    };
  };
}
