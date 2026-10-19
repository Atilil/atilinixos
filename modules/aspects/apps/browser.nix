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
    config,
    pkgs,
    lib,
    ...
  }: {
    # Per-user Firefox policies for Zen, baked into the wrapper. Empty = stock package.
    # Helium (Chromium) policies are per host instead (programs.chromium).
    options.browser.zen.extraPolicies = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Extra Firefox policies merged into the Zen wrapper (wrapFirefox extraPolicies).";
    };
    # Autoconfig lines for the wrapper (zen.* prefs are not allowed in policies).
    options.browser.zen.extraPrefs = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra autoconfig (mozilla.cfg) lines for the Zen wrapper, e.g. defaultPref(...).";
    };

    config.home.packages = [
      (
        let
          zenPkgs = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system};
          unwrapped = zenPkgs.beta-unwrapped;
        in
          if config.browser.zen.extraPolicies == {} && config.browser.zen.extraPrefs == ""
          then zenPkgs.default
          # Mirrors the flake's wrap-zen.nix: wrapFirefox must see the Gecko version to pick its ffmpeg.
          else
            pkgs.wrapFirefox (unwrapped // {version = unwrapped.firefoxVersion or "9999";}) {
              inherit (unwrapped) version;
              icon = "zen-browser";
              extraPolicies = config.browser.zen.extraPolicies;
              extraPrefs = config.browser.zen.extraPrefs;
            }
      )
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
