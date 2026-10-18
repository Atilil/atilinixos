_: {
  den.aspects.shell = {
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [tlrc];
      services.tldr-update = {
        enable = true;
        package = pkgs.tlrc;
        period = "weekly";
      };
      xdg.configFile."tlrc/config.toml".text = ''
        [cache]
        defer_auto_update = true

        [output]
        compact = true
      '';
    };
  };
}
