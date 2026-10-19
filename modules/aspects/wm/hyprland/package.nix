_: {
  # Fixes DisplayLink/evdi hotplug: https://github.com/hyprwm/aquamarine/issues/311
  # 0.12.1 is the version upstream Hyprland 0.55.4 ships with.
  # TODO: drop once https://github.com/NixOS/nixpkgs/pull/576098 reaches nixos-26.05.
  den.aspects.hyprland.os = {lib, ...}: {
    nixpkgs.overlays = [
      (final: prev: {
        aquamarine =
          if lib.versionOlder prev.aquamarine.version "0.12.1"
          then
            prev.aquamarine.overrideAttrs (old: {
              version = "0.12.1";
              src = final.fetchFromGitHub {
                owner = "hyprwm";
                repo = "aquamarine";
                tag = "v0.12.1";
                hash = "sha256-cUQENbJn0PHQUttXame5+PbGGew+BckHZFTfpb8XGI8=";
              };
            })
          else prev.aquamarine;
      })
    ];
  };
}
