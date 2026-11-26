{
  den,
  config,
  ...
}: let
  # Admin public key, defined once in den.nix (flake.lib) so remote-access.nix can reuse it.
  inherit (config.flake.lib) adminSshKey;
in {
  den.aspects.yoann = {
    includes = with den; [
      batteries.primary-user
      (batteries.user-shell "zsh")
      aspects.shell
      aspects.hyprland
      aspects.dev
      aspects.ai
      aspects.obsidian
      aspects.taskwarrior
      aspects.messaging
      aspects.thunderbird
      aspects.bitwarden
      aspects.webos
      aspects.remmina
      aspects.desktop-apps
      # aspects.vial
    ];

    user = {config, ...}: {
      hashedPasswordFile = config.sops.secrets.yoann_password.path;
      extraGroups = ["docker" "gamemode"];
      openssh.authorizedKeys.keys = [adminSshKey];
    };

    homeManager.userInfo = {
      realName = "Yoann Mathon";
      names = {
        gitName = "Atilili";
      };
      emails = {
        primary = "yoann@macopla.com";
        admin = "admin@macopla.com";
        secondary = "fenrisfr@gmail.com";
      };
      publicKeys = {
        macopla_root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFM6msAQtQM2H5CtSTtuJ03Pn6cSYQ7swOjBy1TIgsJr SSH - Macopla Root";
        forgejo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALa9tW6+3eWWGwFCPJk/8m3AJNi2YeeL9o15cMovFZ0 SSH - Forgejo";
        gitlab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOB10n0wXfQ0M1Np1jNe01TBnd/9sYNWla0SRxYEzYoF SSH - Gitlab";
      };
    };
  };
}
