{inputs, ...}: {
  # Upstream Hyprland (same 0.55.4 as nixpkgs) for its newer aquamarine: nixpkgs 26.05's aquamarine 0.11.0
  # breaks DisplayLink/evdi hotplug (aquamarine#311, fixed in 0.12.0). No nixpkgs follows, so
  # hyprland.cachix.org (see core.nix) serves binaries.
  flake-file.inputs.hyprland.url = "github:hyprwm/Hyprland/v0.55.4";

  den.aspects.hyprland.os = {pkgs, ...}: let
    hyprPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs.hyprland = {
      package = hyprPkgs.hyprland;
      portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
    };
  };
}
