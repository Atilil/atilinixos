_: {
  den.aspects.nvf.homeManager = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      extraPlugins.remote-sshfs = {
        package = pkgs.vimPlugins.remote-sshfs-nvim;
        setup = ''
          require('remote-sshfs').setup {
            connections = {
              sshfs_args = { "-o", "reconnect", "-o", "ConnectTimeout=5" },
            },
            mounts = {
              base_dir = "/tmp/remote-sshfs",
              unmount_on_exit = true,
            },
            handlers = {
              on_connect = { change_dir = true },
            },
            ui = {
              confirm = { connect = true, change_dir = false },
            },
            log = {
              enable = false,
              truncate = false,
              types = { "debug", "info", "warn", "error" },
            },
          }
          require('telescope').load_extension 'remote-sshfs'
        '';
      };
      extraPackages = [pkgs.sshfs];
      keymaps = [
        {
          key = "<Leader>rc";
          mode = ["n"];
          action = ":RemoteSSHFSConnect<CR>";
          desc = "SSH remote : connecter";
          silent = true;
        }
        {
          key = "<Leader>rd";
          mode = ["n"];
          action = ":RemoteSSHFSDisconnect<CR>";
          desc = "SSH remote : déconnecter";
          silent = true;
        }
        {
          key = "<Leader>rf";
          mode = ["n"];
          action = ":RemoteSSHFSFindFiles<CR>";
          desc = "SSH remote : chercher fichiers";
          silent = true;
        }
        {
          key = "<Leader>rg";
          mode = ["n"];
          action = ":RemoteSSHFSLiveGrep<CR>";
          desc = "SSH remote : live grep";
          silent = true;
        }
      ];
    };
  };
}
