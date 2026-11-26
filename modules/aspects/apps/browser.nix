{inputs, ...}: {
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.browser.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.zen-browser.homeModules.default];
    config = {
      programs = {
        zen-browser = {
          enable = true;
          release = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta-unwrapped.firefoxVersion;
        };
      };
      home.packages = [
        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = lib.mkOverride 60 "zen-beta.desktop";
          "x-scheme-handler/http" = lib.mkOverride 60 "zen-beta.desktop";
          "x-scheme-handler/https" = lib.mkOverride 60 "zen-beta.desktop";
        };
      };
    };
  };

  den.aspects.browser.os = {
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
