{inputs, ...}: {
  den.aspects.hyprland = {
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

    homeManager = {pkgs, ...}: {
      imports = [inputs.noctalia.homeModules.default];

      home.packages = [pkgs.wl-clipboard];

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
