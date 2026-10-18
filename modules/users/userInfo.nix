{lib, ...}: {
  den.aspects.userInfo = {
    homeManager = _: {
      options.userInfo = {
        realName = lib.mkOption {
          type = lib.types.str;
          description = "Real user Name";
        };
        names = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "List of user names";
        };
        emails = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "List of user mail address";
        };
        publicKeys = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {};
          description = "SSH public keys (the private halves live in the Bitwarden agent)";
        };
      };
    };
  };
}
