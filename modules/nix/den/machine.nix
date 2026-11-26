_: {
  # Hardware facts set by each host, read by user aspects through osConfig
  den.default.os = {lib, ...}: {
    options.machine.screen = lib.mkOption {
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          width = lib.mkOption {type = lib.types.int;};
          height = lib.mkOption {type = lib.types.int;};
        };
      });
      default = null;
      description = "Resolution of the main screen.";
    };
  };
}
