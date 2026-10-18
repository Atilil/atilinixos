_: {
  den.aspects.dev = {
    homeManager = {pkgs, ...}: {
      programs.gpg.enable = true;

      services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        pinentry.package = pkgs.pinentry-qt;
        defaultCacheTtl = 3600;
        maxCacheTtl = 86400;
      };
    };
  };
}
