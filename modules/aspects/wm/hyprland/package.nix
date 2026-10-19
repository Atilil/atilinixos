_: {
  # nixpkgs 26.05's aquamarine 0.11.0 breaks DisplayLink/evdi hotplug (aquamarine#311, fixed in 0.12.0).
  # 0.12.1 is what upstream Hyprland 0.55.4 ships. Remove once NixOS/nixpkgs#576098 (fix backport) reaches nixos-26.05.
  den.aspects.hyprland.os = {lib, ...}: {
    nixpkgs.overlays = [
      (final: prev:
        lib.optionalAttrs (lib.versionOlder prev.aquamarine.version "0.12.1") {
          aquamarine = prev.aquamarine.overrideAttrs (old: {
            version = "0.12.1";
            src = final.fetchFromGitHub {
              owner = "hyprwm";
              repo = "aquamarine";
              tag = "v0.12.1";
              hash = "sha256-cUQENbJn0PHQUttXame5+PbGGew+BckHZFTfpb8XGI8=";
            };
          });
        })
    ];
  };
}
