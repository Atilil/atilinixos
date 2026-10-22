{
  lib,
  den,
  inputs,
  ...
}: let
  # Single source of truth for hosts and users
  fleet = {
    x86_64-linux = {
      laptop = ["yoann" "audrey"];
      ideapad = ["maria"];
    };
  };

  # Shared by NixOS and standalone HM
  nixpkgsConfig = {
    allowUnfree = true;
  };

  # Exposes nixpkgs-unstable as pkgs.unstable.<pkg> (usage: programs.foo.package = pkgs.unstable.foo).
  # Imported rather than legacyPackages so allowUnfree applies.
  unstableOverlay = _: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config = nixpkgsConfig;
    };
  };

  # Local flake checkout, same path on every fleet host. Exposed as flake.lib.flakePath
  # and injected as the `flakePath` module arg in both os and homeManager classes.
  flakePath = "/home/yoann/Projets/nixos";

  # mkHosts: ["u1" "u2"] -> { users = { u1 = {}; u2 = {}; }; }
  # mkHomes: "host" ["u1" "u2"] -> { "u1@host" = {}; "u2@host" = {}; }
  mkHosts = users: {
    users = lib.genAttrs users (_: {});
  };
  mkHomes = host: users: let
    names = map (u: "${u}@${host}") users;
  in
    lib.genAttrs names (_: {});
in {
  flake.lib = {
    inherit flakePath;
    # Admin public key, authorised on root of remote hosts. flake.lib is single-definition: keep it here.
    adminSshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmioSel9+Ui/9dLqOQiQ6kV+LFzkvzjXS0VIQeS0ZeQ";
  };

  den = {
    default = {
      os = _: {
        _module.args.flakePath = flakePath;

        # WARNING: set at the initial installation, never change
        system.stateVersion = "25.11";

        # Integrated HM inherits this; standalone HM redeclares it below
        nixpkgs.config = nixpkgsConfig;

        # pkgs.unstable.<pkg> for every NixOS module (and integrated HM via useGlobalPkgs)
        nixpkgs.overlays = [unstableOverlay];
      };

      homeManager = {
        config,
        lib,
        ...
      }: {
        _module.args.flakePath = flakePath;

        # WARNING: set at the initial installation, never change
        home.stateVersion = "25.11";

        # Integrated HM inherits nixpkgs from NixOS; standalone HM needs its own config.
        # HACK: den's insecureModule keys on osConfig.useGlobalPkgs, which is true for standalone HM too,
        # so it skips the standalone nixpkgs; re-emit the battery value here.
        nixpkgs.config = lib.mkIf (!config.submoduleSupport.enable) (
          nixpkgsConfig
          // {
            permittedInsecurePackages = config.permittedInsecurePackages.packages or [];
          }
        );

        # Standalone HM only: integrated HM inherits overlays from NixOS above
        nixpkgs.overlays = lib.mkIf (!config.submoduleSupport.enable) [unstableOverlay];
      };
    };

    schema = {
      # Home Manager for every user, unless a user's classes say otherwise
      user.classes = lib.mkDefault ["homeManager"];

      # Aspects common to all entities (hosts, users, homes)
      conf.includes = [];

      # Aspects common to all hosts: add here instead of repeating in each host
      host.includes = with den.aspects; [home-manager plymouth];

      # Aspects common to all users: add here instead of repeating in each user
      user.includes = with den; [
        batteries.define-user
        aspects.browser
        aspects.userDirs
        aspects.userInfo
        aspects.whatsapp
      ];

      # Aspects common to all standalone HM configs
      home.includes = with den; [
        batteries.define-user
        aspects.browser
        aspects.userDirs
        aspects.userInfo
      ];
    };

    # See https://den.denful.dev/guides/declare-hosts/
    hosts =
      lib.mapAttrs (
        _: systemHosts:
          lib.mapAttrs (_: mkHosts) systemHosts
      )
      fleet;

    # Standalone HM configs (nh home switch -c user@host), see
    # https://den.denful.dev/guides/home-manager/
    homes =
      lib.mapAttrs (
        _: systemHosts:
          lib.mergeAttrsList (lib.mapAttrsToList mkHomes systemHosts)
      )
      fleet;
  };
}
