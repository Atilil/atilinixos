{config, ...}: {
  # OpenSSH reads the public file to pick which key to ask the agent for
  home.file.".ssh/forgejo.pub".text = "${config.userInfo.publicKeys.forgejo} SSH - Forgejo\n";

  # Declarative host keys for the family fleet (ideapad = maria's laptop, via VPN).
  home.file.".ssh/known_hosts_fleet".text = ''
    ideapad.macopla.home,10.86.99.7 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwBPXsY40GDffLh3UKf/LE6arCB/YeQ64fWox5+Hjzs
  '';

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
      # Maria's laptop, as root. First match wins: beats the `yoann` of the canonical block below.
      "ideapad ideapad.macopla.home" = {
        User = "root";
      };
      "Match canonical Host *.macopla.home,10.86.*" = {
        User = "yoann";
        IdentityFile = "~/.ssh/macopla";
        IdentitiesOnly = true;
      };
      # Self-hosted Forgejo: Git-over-SSH listens on 2222, not 22
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
