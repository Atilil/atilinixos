_: {
  den.aspects.shell = {
    homeManager = _: {
      home.sessionVariables = {
        # Silence zoxide's init-order "doctor" warning
        _ZO_DOCTOR = "0";

        _ZO_FZF_OPTS =
          "--height 60% --layout reverse --border --info inline --color=16 "
          + "--preview 'eza -1 --icons --color=always --group-directories-first {2..}'";

        _ZO_RESOLVE_SYMLINKS = "1";
      };
      programs = {
        zoxide = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          options = ["--cmd cd"];
        };
      };
    };
  };
}
