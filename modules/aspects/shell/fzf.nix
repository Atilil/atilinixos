_: {
  den.aspects.shell = {
    homeManager = _: {
      programs = {
        fzf = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;

          # Global UI, mirrors the fzf-tab look in shell.nix
          defaultOptions = [
            "--height 60%"
            "--layout reverse"
            "--border"
            "--info inline"
            # ANSI 0-15 only, so colors follow Noctalia via kitty
            "--color=16"
          ];

          # CTRL-T: file search with bat preview
          fileWidgetOptions = [
            "--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
          ];

          # ALT-C: cd with eza preview
          changeDirWidgetOptions = [
            "--preview 'eza -1 --icons --color=always --group-directories-first {}'"
          ];
        };
      };
    };
  };
}
