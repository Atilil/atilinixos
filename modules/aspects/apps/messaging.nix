{den, ...}: {
  den.aspects = {
    # Aggregator: pulls in all messaging tools for users who want the full stack
    messaging.includes = with den.aspects; [
      telegram
      vesktop
      thunderbird
    ];

    # WhatsApp has no Linux app: ZapZap wraps WhatsApp Web (Qt, tray, notifications).
    # Settings are merged into ZapZap.conf at activation (not programs.zapzap.settings):
    # ZapZap writes onboarding/geometry there and needs the file writable.
    whatsapp.homeManager = {
      lib,
      pkgs,
      ...
    }: {
      programs.zapzap.enable = true;
      home.activation.zapzapSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
        f="$HOME/.config/ZapZap/ZapZap.conf"
        run mkdir -p "$(dirname "$f")"
        for kv in "notification donation_message false" "system wayland true" "website open_page false"; do
          set -- $kv
          run ${pkgs.crudini}/bin/crudini --set "$f" "$1" "$2" "$3"
        done
      '';
    };

    telegram.homeManager = {pkgs, ...}: {
      home.packages = [pkgs.telegram-desktop];
    };

    vesktop.homeManager = _: {
      programs.vesktop = {
        enable = true;
        settings = {
          discordbranch = "stable";
          transparencyOption = "mica";
          tray = true;
          minimizeToTray = true;
          autoStartMinimized = true;
          openLinkWithElectron = false;
          staticTitle = false;
          enableMenu = true;
          disableSmoothScroll = false;
          hardwareAcceleration = true;
          hardwareVideoAcceleration = true;
          arRPC = true;
          appBadges = true;
          enableTaskbarFlashing = false;
          disableMinSize = true;
          clickTrayToShowHide = true;
          customTitlebar = false;
          enableSpashScreen = false;
          spellCheckLanguages = ["en-US,fr-FR"];
        };
        vencord = {
          settings = {
            autoUpdate = true;
            autoUpdateNotifications = true;
            frameless = true;
            transparent = true;
          };
          useSystem = true;
        };
      };
    };

    thunderbird.homeManager = {config, ...}: {
      programs.thunderbird = {
        enable = true;
        profiles.${config.home.username} = {
          isDefault = true;
          search.default = "ddg";
          search.force = true;
        };
        settings = {
          "accessibility.typeaheadfind.flashBar" = 0;
          "browser.policies.applied" = true;
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
          "datareporting.policy.dataSubmissionPolicyNotifiedTime" = 1777420605835;
          "do-rollout.home-region" = "FR";
          "mail.close_message_window.on_delete" = true;
          "mail.compose.big_attachments.threshold_kb" = 10240;
          "mail.spam.logging.enabled" = true;
          "mail.spam.manualMark" = true;
          "mail.tabs.autoHide" = false;
          "mail.threadpane.cardsview.rowcount" = 2;
          "mail.ui-rdf.version" = 57;
          "mail.uidensity" = 0;
          "mailnews.message_display.disable_remote_image" = false;
          "mailnews.start_page.enabled" = false;
          "spellchecker.dictionary" = "en-US,fr";
          "extensions.ui.dictionary.hidden" = true;
          "app.update.langpack.enabled" = true;
          # Required for Noctalia's userChrome.css (ignored by default)
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };
  };
}
