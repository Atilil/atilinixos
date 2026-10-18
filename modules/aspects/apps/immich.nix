_: {
  den.aspects.immich.homeManager = {pkgs, ...}: let
    immichLogo = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/immich-app/immich/v3.3.3/design/immich-logo.svg";
      hash = "sha256-36XvcE0HhUkUMGwMIkFzvaJxD4/A3/6314aQ9Y+YEaY=";
    };
  in {
    # Immich logo in hicolor (fallback of every icon theme).
    xdg.dataFile."icons/hicolor/scalable/apps/immich.svg".source = immichLogo;

    # No Linux Immich client: web app in a Helium --app window (no tabs/address bar).
    # TODO: StartupWMClass is unverified on Helium/Wayland; check if the window
    # is not grouped under its pinned launcher.
    xdg.desktopEntries.immich = {
      name = "Photos";
      genericName = "Immich";
      exec = "helium --app=https://photo.macopla.com";
      icon = "immich"; # xdg.dataFile above
      categories = ["Graphics" "Network"];
      settings.StartupWMClass = "chrome-photo.macopla.com__-Default";
    };
  };
}
