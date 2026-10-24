_: {
  den.aspects.nvf.homeManager = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      # Key must equal the package pname: nvf aborts on a mismatch.
      lazy.plugins."remote-sshfs.nvim" = {
        package = pkgs.vimPlugins.remote-sshfs-nvim;
        # The plugin only creates its commands inside setup(), so lz.n must own them.
        cmd = [
          "RemoteSSHFSConnect"
          "RemoteSSHFSDisconnect"
          "RemoteSSHFSEdit"
          "RemoteSSHFSReload"
          "RemoteSSHFSFindFiles"
          "RemoteSSHFSLiveGrep"
        ];
        keys = [
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
        setupModule = "remote-sshfs";
        setupOpts = {
          connections = {
            sshfs_args = ["-o" "reconnect" "-o" "ConnectTimeout=5"];
          };
          mounts = {
            base_dir = "/tmp/remote-sshfs";
            unmount_on_exit = true;
          };
          handlers = {
            on_connect = {change_dir = true;};
          };
          ui = {
            confirm = {
              connect = true;
              change_dir = false;
            };
          };
          log = {
            enable = false;
            truncate = false;
            types = ["debug" "info" "warn" "error"];
          };
        };
        # Telescope is lazy too: load it here, not at startup, so its extensions
        # (fzf, frecency, undo...) are only paid for when remote-sshfs is used.
        # Runs after setupModule's setup() call.
        after = ''
          require('lz.n').trigger_load 'telescope'
          require('telescope').load_extension 'remote-sshfs'
        '';
      };
      extraPackages = [pkgs.sshfs];
    };
  };
}
