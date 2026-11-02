_: {
  den.aspects.hyprland.homeManager.xdg.configFile."kitty/scratch.kitty-session".text = ''
    new_tab [Tasks]
    launch --title=scratch-tasks kitten run-shell taskwarrior-tui

    new_tab [Shell]
    launch
  '';
}
