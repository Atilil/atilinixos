{pkgs, ...}: let
  thunderbirdLangpackFr = pkgs.fetchurl {
    url = "https://ftp.mozilla.org/pub/thunderbird/releases/${pkgs.thunderbird.version}/linux-x86_64/xpi/fr.xpi";
    hash = "sha256-RQ0gA1QWvpelEaraWMQHwgdcMpVOb6mxeC5csMsEnYY="; # Thunderbird 157.0.1
  };
in {
  # Hotmail/Outlook: the flavor sets IMAP/SMTP hosts and OAuth2.
  accounts.email.accounts."maria" = {
    primary = true;
    realName = "Maria";
    address = "maria-maziere" + "@" + "hotmail.com";
    flavor = "outlook.office365.com";
    thunderbird.enable = true;
  };

  # French UI: langpack force-installed + locale requested via policies.
  programs.thunderbird.policies = {
    RequestedLocales = ["fr"];
    ExtensionSettings."langpack-fr@thunderbird.mozilla.org" = {
      installation_mode = "force_installed";
      install_url = "file://${thunderbirdLangpackFr}";
    };
  };
}
