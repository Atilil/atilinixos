{
  den,
  inputs,
  ...
}: {
  den.aspects.maria = {
    includes = with den; [
      (batteries.import-tree ./hm)
      aspects.plasma
      aspects.plasma-rice
      aspects.plasma-layout
      aspects.remote-access
      aspects.bitwarden
      aspects.thunderbird
      aspects.office
      aspects.jellyfin
      aspects.elisa
      aspects.immich
    ];

    homeManager = _: {
      # hm/ modules (zen.nix) read flake inputs.
      _module.args.inputs = inputs;
      userInfo.realName = "Maria";
      plasmaLayout.screen = {
        width = 1600;
        height = 900;
      };
    };

    user = {
      description = "Maria";
      extraGroups = ["networkmanager" "wheel"];
    };
  };
}
