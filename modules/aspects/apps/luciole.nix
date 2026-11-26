{inputs, ...}: {
  # No release tags yet: tracks the `cachix` branch (commits cached by upstream CI).
  # No `follows`: overriding nixpkgs changes the hash and misses the cache.
  flake-file.inputs.luciole.url = "github:noctalia-dev/luciole/cachix";

  den.aspects.luciole.homeManager = {
    imports = [inputs.luciole.homeModules.default];

    programs.luciole.enable = true;

    xdg.mimeApps.defaultApplications."inode/directory" = "dev.noctalia.luciole.desktop";
  };

  # FileChooser portal backend; each compositor aspect selects it in its portals config
  den.aspects.luciole.os = {pkgs, ...}: {
    xdg.portal.extraPortals = [inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
}
