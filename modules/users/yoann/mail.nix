_: {
  den.aspects.yoann.homeManager = {config, ...}: let
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
      "yoann" =
        mkMailcow {
          realName = config.userInfo.realName;
          address = config.userInfo.emails.primary;
          primary = true;
        }
        // {
          aliases = [config.userInfo.emails.admin];
        };
      "fenrisfr" = {
        enable = true;
        thunderbird.enable = true;
        realName = "Fenrisfr";
        address = config.userInfo.emails.secondary;
        flavor = "gmail.com";
      };
    };

    # Personal Thunderbird fonts (the shared thunderbird aspect stays neutral).
    programs.thunderbird.settings = {
      "font.name.sans-serif.x-western" = "JetBrainsMono Nerd Font";
      "msgcompose.font_face" = "JetBrainsMono Nerd Font";
    };

    # account2 = Unified Folders; HM drops it from the list every start, so TB recreates it
    # https://github.com/nix-community/home-manager/issues/5031
    programs.thunderbird.profiles.${config.home.username}.accountsOrder = [
      "fenrisfr"
      "yoann"
      "account2"
    ];
  };
}
