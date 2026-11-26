_: {
  den.aspects.thunderbird.homeManager = {config, ...}: {
    programs.thunderbird = {
      enable = true;
      profiles.${config.home.username} = {
        isDefault = true;
        search.default = "ddg";
        search.force = true;
      };
      settings = {
        "accessibility.typeaheadfind.flashBar" = 0;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "datareporting.healthreport.uploadEnabled" = false;
        # Both keys together hide the data-submission notice bar
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        "datareporting.policy.dataSubmissionPolicyNotifiedTime" = 1777420605835;
        "mail.close_message_window.on_delete" = true;
        "mail.compose.big_attachments.threshold_kb" = 10240;
        "mail.spam.logging.enabled" = true;
        "mail.spam.manualMark" = true;
        "mail.tabs.autoHide" = false;
        "mail.threadpane.cardsview.rowcount" = 2;
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
}
