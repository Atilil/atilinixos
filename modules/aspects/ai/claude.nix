_: {
  den.aspects.ai.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = [pkgs.python3];

    programs.claude-code = {
      enable = true;
      package = lib.mkDefault pkgs.unstable.claude-code;
      enableMcpIntegration = true;
    };
  };
}
