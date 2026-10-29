{config, ...}: {
  # OpenSSH reads the public file to pick which key to ask the agent for
  home.file = {
    ".ssh/forgejo.pub".text = "${config.userInfo.publicKeys.forgejo}";
    ".ssh/gitlab.pub".text = "${config.userInfo.publicKeys.gitlab}";
    ".ssh/macopla_root.pub".text = "${config.userInfo.publicKeys.macopla_root}";
    # Declarative host keys for the family fleet (ideapad = maria's laptop, via VPN).
    ".ssh/known_hosts_fleet".text = ''ideapad.macopla.home,10.86.99.7 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwBPXsY40GDffLh3UKf/LE6arCB/YeQ64fWox5+Hjzs'';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        CanonicalizeHostname = true;
        CanonicalDomains = "macopla.home";
        CanonicalizeMaxDots = 0;
        UserKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/known_hosts_fleet";
      };
      "ideapad ideapad.macopla.home" = {
        User = "root";
      };
      "Match canonical Host *.macopla.home,10.86.* User *,!root" = {
        User = "yoann";
        IdentityFile = "~/.ssh/macopla";
        IdentitiesOnly = true;
      };
      "Match canonical Host *.macopla.home,10.86.* User root" = {
        IdentityFile = "~/.ssh/macopla_root";
        IdentitiesOnly = true;
      };

      # GIT
      "forge.macopla.com" = {
        Port = 2222;
        User = "git";
        IdentityFile = "~/.ssh/forgejo.pub";
        IdentitiesOnly = true;
      };
      "gitlab.com" = {
        User = "git";
        IdentityFile = "~/.ssh/gitlab.pub";
        IdentitiesOnly = true;
      };
    };
  };
}
