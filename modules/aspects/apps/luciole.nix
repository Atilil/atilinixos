{inputs, ...}: {
  flake-file.inputs.luciole.url = "github:noctalia-dev/luciole/cachix";
  den.aspects.luciole.homeManager = {
    imports = [inputs.luciole.homeModules.default];
    programs.luciole.enable = true;
    xdg.mimeApps.defaultApplications."inode/directory" = "dev.noctalia.luciole.desktop";
  };
  den.aspects.luciole.os = {pkgs, ...}: {
    xdg.portal.extraPortals = [inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
}
