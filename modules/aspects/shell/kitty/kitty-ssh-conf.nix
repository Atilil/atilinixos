_: {
  den.aspects.kitty.homeManager = {config, ...}: {
    xdg.configFile = {
      "kitty/ssh.conf".text = ''
        shell_integration enabled

        # Portable vimrc, synced fresh each connection into a dedicated cache
        # dir -- never touches the remote's own .vimrc.
        env VIMINIT=source $HOME/.cache/kitty-ssh/vimrc
        copy --dest=.cache/kitty-ssh/vimrc ${config.home.file.".vimrc".source}
      '';
    };
  };
}
