{inputs, ...}: {
  flake-file.inputs = {
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  den.aspects.browser.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.zen-browser.homeModules.default];

    # No profiles declared: existing Zen profiles stay unmanaged.
    config.programs.zen-browser = {
      enable = true;
      # Zen's own version is not a Firefox one; langpack URLs need the Gecko version.
      release = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta-unwrapped.firefoxVersion;
    };

    config.home.packages = [
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # HACK: nixpkgs firefoxpwa 2.18.2 installPhase misses mkdir -p; re-enable once fixed.
    config.programs.firefoxpwa.enable = false;

    config.xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = lib.mkOverride 60 "zen-beta.desktop";
        "x-scheme-handler/http" = lib.mkOverride 60 "zen-beta.desktop";
        "x-scheme-handler/https" = lib.mkOverride 60 "zen-beta.desktop";
      };
    };
  };

  # Helium reads policies only from /etc/chromium/policies/managed (system-wide, no
  # per-user dir): French UI, no telemetry/sign-in/password manager.
  # Bitwarden is installed by hand once: Helium blocks Google's CRX endpoint.
  den.aspects.ideapad.includes = [
    {
      os = _: {
        programs.chromium = {
          enable = true;
          extraOpts = {
            ApplicationLocaleValue = "fr";
            BrowserSignin = 0;
            MetricsReportingEnabled = false;
            PasswordManagerEnabled = false;
            DefaultBrowserSettingEnabled = false;
          };
        };
      };
    }
  ];
}
