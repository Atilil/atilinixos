_: {
  den.aspects.shell = {
    homeManager = _: {
      programs = {
        eza = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          git = true;
          icons = "always";
          # Injected via the generated `eza` alias
          extraOptions = [
            "--group-directories-first"
            "--hyperlink" # clickable filenames in kitty
            "--git-repos"
          ];
        };
      };
    };
  };
}
