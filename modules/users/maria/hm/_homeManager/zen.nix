_: let
  # Bitwarden extension ID on Firefox
  bitwardenFirefoxId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
in {
  programs.zen-browser.languagePacks = ["fr"];

  programs.zen-browser.policies = {
    DisableAppUpdate = true;
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    DontCheckDefaultBrowser = true;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;
    RequestedLocales = ["fr"];
    ExtensionSettings = {
      ${bitwardenFirefoxId} = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      };
      "uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
    };
  };

  # Her Zen settings, as defaults: she can still change them in the GUI.
  programs.zen-browser.extraPrefs = ''
    defaultPref("browser.translations.alwaysTranslateLanguages", "en");
    defaultPref("extensions.formautofill.addresses.enabled", false);
    defaultPref("extensions.formautofill.creditCards.enabled", false);
    defaultPref("signon.management.page.breach-alerts.enabled", false);
    defaultPref("network.dns.disablePrefetch", true);
    defaultPref("network.prefetch-next", false);
    defaultPref("network.http.speculative-parallel-limit", 0);
    defaultPref("privacy.clearOnShutdown_v2.formdata", true);
    defaultPref("sidebar.visibility", "hide-on-close");
    defaultPref("zen.glance.enabled", false);
    defaultPref("zen.themes.disable-all", true);
    defaultPref("zen.urlbar.behavior", "normal");
    defaultPref("zen.view.compact.enable-at-startup", false);
    defaultPref("zen.view.use-single-toolbar", false);
    defaultPref("zen.workspaces.continue-where-left-off", true);
    defaultPref("zen.workspaces.force-container-workspace", true);
    defaultPref("zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url", true);
  '';
}
