{config, ...}: let
  mkMailcow = {
    realName,
    address,
    primary ? false,
  }: {
    enable = true;
    thunderbird.enable = true;
    userName = address;
    inherit realName;
    inherit address;
    inherit primary;
    imap = {
      host = "mail.macopla.com";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "mail.macopla.com";
      port = 465;
      tls.enable = true;
    };
  };
in {
  accounts.email.accounts = {
    "yoann" = mkMailcow {
      realName = config.userInfo.realName;
      address = config.userInfo.emails.primary;
      primary = true;
    };
    "admin" = mkMailcow {
      realName = "Admin Macopla";
      address = config.userInfo.emails.admin;
    };
    "fenrisfr" = {
      enable = true;
      thunderbird.enable = true;
      realName = "Fenrisfr";
      address = config.userInfo.emails.secondary;
      flavor = "gmail.com";
    };
  };
}
