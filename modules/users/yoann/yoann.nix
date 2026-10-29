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
      (batteries.import-tree ./hm)
      (batteries.user-shell "zsh")
      aspects.shell
      aspects.hyprland
      aspects.dev
      aspects.ai
      aspects.obsidian
      aspects.messaging
      aspects.bitwarden
      aspects.webos
      aspects.remmina
      # aspects.vial
    ];

    homeManager = {
      config,
      pkgs,
      ...
    }: {
      # Personal Thunderbird fonts (the shared thunderbird aspect stays neutral).
      programs.thunderbird.settings = {
        "font.name.sans-serif.x-western" = "JetBrainsMono Nerd Font";
        "msgcompose.font_face" = "JetBrainsMono Nerd Font";
      };

      # account2 = Unified Folders; HM drops it from the list every start, so TB recreates it
      # https://github.com/nix-community/home-manager/issues/5031
      programs.thunderbird.profiles.${config.home.username}.accountsOrder = [
        "admin"
        "fenrisfr"
        "yoann"
        "account2"
      ];

      userInfo = {
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

      wayland.windowManager.hyprland.settings.config.input = {
        kb_layout = "us,us";
        kb_variant = "intl,";
        kb_options = "grp:win_space_toggle,eurosign:e,caps:escape";
      };

      home.sessionVariables = {
        SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
        EDITOR = "vim";
        VISUAL = "vim";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        OZONE_PLATFORM = "wayland";
      };

      # HACK: nixpkgs bug: the firefox/thunderbird wrapper no longer sets these gsettings schema paths,
      # breaking GTK/Pango text rendering on non-GNOME sessions
      xdg.systemDirs.data = [
        "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      ];
    };

    user = {config, ...}: {
      hashedPasswordFile = config.sops.secrets.yoann_password.path;
      extraGroups = ["docker" "gamemode"];
      openssh.authorizedKeys.keys = [adminSshKey];
    };

    provides.to-hosts.os = _: let
      mkUserSecret = _: {
        sopsFile = ./sops/secrets.yaml;
        owner = "yoann";
        mode = "0400";
      };
    in {
      # User secrets (API tokens); yoann_password lives in sops.nix (neededForUsers)
      sops.secrets = {
        github_token_yoann = mkUserSecret "github_token_yoann";
        codestral_api_key_yoann = mkUserSecret "codestral_api_key_yoann";
      };
    };
  };
}
