{inputs, ...}: {
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  den.aspects.plasma = {
    # Module and shared behaviour; the look is plasma-rice, the layout is per user.
    homeManager = {
      imports = [inputs.plasma-manager.homeModules.plasma-manager];

      programs.plasma = {
        input.keyboard.numlockOnStartup = "on";
        session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };
    };

    os = {
      config,
      pkgs,
      lib,
      ...
    }: {
      # No display manager here: the greeter aspect (greetd) logs in.
      services.desktopManager.plasma6.enable = true;

      # Wayland session only (plasma6 has no option to drop the X11 one); keep Hyprland's if present.
      services.displayManager.sessionPackages = lib.mkForce (
        [
          (pkgs.runCommand "plasma-wayland-session" {
              passthru.providedSessions = ["plasma"];
            } ''
              mkdir -p $out/share
              ln -s ${pkgs.kdePackages.plasma-workspace.sessions}/share/wayland-sessions $out/share/wayland-sessions
            '')
        ]
        ++ lib.optional config.programs.hyprland.enable config.programs.hyprland.package
      );

      # Override seahorse's askpass (security aspect) with the KDE one.
      programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    };
  };
}
