_: {
  den.aspects.dev.homeManager = {
    pkgs,
    config,
    ...
  }: {
    programs.rbw = {
      enable = true;
      settings = {
        email = config.userInfo.emails.admin;
        base_url = "https://vault.macopla.com/";
        pinentry = pkgs.pinentry-curses;
        lock_timeout = 86400;
      };
    };
  };
}
