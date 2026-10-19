{
  inputs,
  lib,
  config,
  ...
}: let
  # Users per host come from den.hosts, so adding a user needs no edit here
  # (secrets are <user>_password, root included).
  allHostsFlat = lib.mergeAttrsList (builtins.attrValues config.den.hosts);
  hostUsers =
    lib.mapAttrs (
      _: hostConfig:
        lib.unique (["root"] ++ builtins.attrNames (hostConfig.users or {}))
    )
    allHostsFlat;
in {
  den.aspects.sops = {
    nixos = {config, ...}: {
      imports = [inputs.sops-nix.nixosModules.sops];
      sops = {
        defaultSopsFile = ./secrets.yaml;
        defaultSopsFormat = "yaml";
        age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        secrets =
          lib.genAttrs
          (map (u: "${u}_password") (hostUsers.${config.networking.hostName} or ["root"]))
          (_: {neededForUsers = true;})
          // {
            forge_deploy_key = {};
            # Group wheel can read it: flake input resolution (github: refs) runs client-side
            # as the invoking user, not through nix-daemon as root.
            nix_access_tokens = {
              group = "wheel";
              mode = "0440";
            };
          };
      };
      # `!include` (not `include`) so a missing secret at first boot does not hard-fail nix-daemon
      nix.extraOptions = ''
        !include ${config.sops.secrets.nix_access_tokens.path}
      '';
    };
  };
}
