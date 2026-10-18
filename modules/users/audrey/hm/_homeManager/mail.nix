_: {
  accounts.email.accounts = {
    "audrey" = {
      enable = true;
      realName = "Audrey ";
      thunderbird.enable = true;
      address = "audrey" + "@" + "macopla.com";
      primary = true;
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
    "popcorn" = {
      enable = true;
      thunderbird.enable = true;
      realName = "Audrey";
      address = "popcorn3364" + "@" + "gmail.com";
      flavor = "gmail.com";
    };
    ${"plan" + "eau"} = {
      enable = true;
      thunderbird.enable = true;
      realName = "Audrey";
      address = "audreyplaneau" + "@" + "gmail.com";
      flavor = "gmail.com";
    };
    ${"planeau_audrey" + "@" + "yahoo.fr"} = {
      enable = true;
      thunderbird.enable = true;
      realName = "Audrey";
      address = "audreyplaneau" + "@" + "yahoo.fr";
      imap = {
        host = "imap.mail.yahoo.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.mail.yahoo.com";
        port = 465;
        tls.enable = true;
      };
    };
    ${"green.beauty.girondine" + "@" + "gmail.com"} = {
      enable = true;
      thunderbird.enable = true;
      realName = "Green Beauty Girondine";
      address = "green.beauty.girondine" + "@" + "gmail.com";
      flavor = "gmail.com";
    };
  };
}
