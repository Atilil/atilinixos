_: {
  den.aspects.yoann.homeManager = {pkgs, ...}: let
    # Rebuilt from src at a reviewed commit (SkillSpector + manual review)
    claude-hud = pkgs.buildNpmPackage {
      pname = "claude-hud";
      version = "0.11.3";
      src = pkgs.fetchFromGitHub {
        owner = "jarrodwatts";
        repo = "claude-hud";
        rev = "5f725e737a882211bb62b8fc56ab593d4d97f18a";
        hash = "sha256-FPPsSSHW15XMKi7mWdjC+icf08ROtkVPm+C3hQsXxX0=";
      };
      npmDepsHash = "sha256-3piDj3//jOpjbJSi787iX3tvHK8cqU38d4EBTyCf55M=";
      installPhase = ''
        mkdir -p $out/lib/claude-hud
        cp -r dist package.json $out/lib/claude-hud/
      '';
    };
  in {
    # On PATH so settings.json calls it by name
    home.packages = [
      (pkgs.writeShellScriptBin "claude-hud" ''
        exec ${pkgs.nodejs}/bin/node ${claude-hud}/lib/claude-hud/dist/index.js "$@"
      '')
    ];
  };
}
