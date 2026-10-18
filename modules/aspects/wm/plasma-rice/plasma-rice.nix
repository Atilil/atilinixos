_: {
  # Shared Plasma look (style only); the layout is plasma-layout.
  den.aspects.plasma-rice = {
    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: let
      # Modern Clock widget (KDE Store). Pinned by commit: upstream tags stop at 0.2.0 (Plasma 5).
      modernClock = pkgs.stdenvNoCC.mkDerivation {
        pname = "plasma-applet-modernclock";
        version = "1.0.0";
        src = pkgs.fetchFromGitHub {
          owner = "prayag2";
          repo = "kde_modernclock";
          rev = "5c86f0f23d2646be7e9872fc5e769bdce259af92";
          hash = "sha256-+FqTNdMbWXp27ZdfcgQvLE+yr2z6KxXbIIPpQTffEIE=";
        };
        installPhase = ''
          mkdir -p $out/share/plasma/plasmoids
          cp -r package $out/share/plasma/plasmoids/com.github.prayag2.modernclock
          # Qt.formatDate ignores the locale: use Qt.locale() so the day/date are in French.
          substituteInPlace $out/share/plasma/plasmoids/com.github.prayag2.modernclock/contents/ui/main.qml \
            --replace-fail 'Qt.formatDate(curDate, "dddd")' 'Qt.locale().toString(curDate, "dddd")' \
            --replace-fail 'Qt.formatDate(curDate, dateFormat)' 'Qt.locale().toString(curDate, dateFormat)'
        '';
      };
      # Sweet-Dark-transparent window decoration (Aurorae, GPLv3), buttons moved to the right like Windows.
      sweetDecoration =
        pkgs.runCommand "aurorae-sweet-dark-transparent-custom" {
          src = pkgs.fetchFromGitHub {
            owner = "Nadir-Alishly";
            repo = "kde-plasma-rice";
            rev = "dc39c93495982383f3534d7d760833cd92014e6a";
            hash = "sha256-Tk4Fs4tlZVWZ+rHRnDWZlRdynoKdsjBQD3sYZkXNc8E=";
          };
        } ''
          d=$out/share/aurorae/themes/Sweet-Dark-transparent-Custom
          mkdir -p $d
          cp -r "$src/custom themes/Sweet-Dark-transparent-Custom/." $d/
          chmod -R u+w $d
          substituteInPlace $d/Sweet-Dark-transparent-Customrc \
            --replace-fail "LeftButtons=XIA" "LeftButtons=" \
            --replace-fail "RightButtons=" "RightButtons=IAX"
        '';
      # Music Waves widget (KDE Store p/2186442, GPL-3.0+): no public repo, vendored.
      musicWaves = pkgs.runCommand "plasma-applet-musicwaves-0.1" {} ''
        mkdir -p $out/share/plasma/plasmoids
        cp -r ${./_plasmoids/Music.Waves} $out/share/plasma/plasmoids/Music.Waves
      '';
    in {
      home.packages = [modernClock musicWaves sweetDecoration];

      # Create the slideshow folder only (never touches its contents).
      home.activation.wallpaperDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run mkdir -p "${config.home.homeDirectory}/Pictures/Fonds d'ecran"
      '';

      programs.plasma = {
        enable = true;

        workspace = {
          # Parts set one by one: a lookAndFeel would override the window decoration.
          colorScheme = "BreezeDark"; # the greeter follows it (greeter.nix)
          theme = "breeze-dark";
          iconTheme = "breeze-dark";
          widgetStyle = "Klassy";
          windowDecorations = {
            library = "org.kde.kwin.aurorae";
            theme = "__aurorae__svg__Sweet-Dark-transparent-Custom";
          };
        };

        # Slideshow from the user's own folder; users can override it.
        workspace.wallpaperSlideShow = lib.mkDefault {
          path = "${config.home.homeDirectory}/Pictures/Fonds d'ecran/";
          interval = 300;
        };

        # One step above the Plasma default (10 pt).
        fonts = let
          font = {
            family = "Noto Sans";
            pointSize = 12;
          };
        in {
          general = font;
          menu = font;
          toolbar = font;
          windowTitle = font;
        };

        # Klassy application style: rounder corners (Breeze: 4) and translucent menus.
        configFile."klassy/klassyrc" = {
          Windeco.WindowCornerRadius = 8;
          Style.MenuOpacity = 85;
        };
      };
    };

    # Klassy's Qt style plugin must be in the system profile.
    os = {pkgs, ...}: {
      environment.systemPackages = [pkgs.klassy];
    };
  };
}
