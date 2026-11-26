{
  lib,
  den,
  inputs,
  ...
}: let
  flakePath = "/home/yoann/Projets/nixos";
  fleet = {
    x86_64-linux = {
      laptop = ["yoann" "audrey"];
      ideapad = ["maria"];
      bigtop = ["yoann"];
    };
  };

  # mkHosts: ["u1" "u2"] -> { users = { u1 = {}; u2 = {}; }; }
  # mkHomes: "host" ["u1" "u2"] -> { "u1@host" = {}; "u2@host" = {}; }
  mkHosts = users: {
    users = lib.genAttrs users (_: {});
  };
  mkHomes = host: users: let
    names = map (u: "${u}@${host}") users;
  in
    lib.genAttrs names (_: {});

  # Exposes nixpkgs-unstable as pkgs.unstable.<pkg> (usage: programs.foo.package = pkgs.unstable.foo).
  # Imported rather than legacyPackages so allowUnfree applies.
  unstableOverlay = _: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config = nixpkgsConfig;
    };
  };
  nixpkgsConfig = {
    allowUnfree = true;
  };
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
        system.stateVersion = "25.11"; # WARNING: set at the initial installation, never change
        nixpkgs.config = nixpkgsConfig;
        nixpkgs.overlays = [unstableOverlay];
      };

      homeManager = {
        config,
        lib,
        ...
      }: {
        _module.args.flakePath = flakePath;
        home.stateVersion = "25.11"; # WARNING: set at the initial installation, never change
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
      user.classes = lib.mkDefault ["homeManager"]; # Home Manager for every user, unless a user's classes say otherwise
      conf.includes = []; # Aspects common to all entities (hosts, users, homes)
      host.includes = with den; [
        # Aspects common to all hosts: add here instead of repeating in each host
        aspects.home-manager
        aspects.plymouth
        # Users' system content (nixos/os, provides.to-hosts) reaches their hosts only on opt-in
        # since https://github.com/denful/den/issues/694
        batteries.user-aspects
        batteries.mutual-provider
      ];

      # Aspects common to all users: add here instead of repeating in each user
      user.includes = with den; [
        batteries.define-user
        aspects.browser
        aspects.userDirs
        aspects.userInfo
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
