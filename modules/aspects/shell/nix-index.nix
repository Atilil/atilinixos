{inputs, ...}: {
  flake-file.inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.shell = {
    homeManager = {
      pkgs,
      lib,
      ...
    }: let
      # Upstream HM module is skipped: it hardcodes the unstable db and links the 99 MB full one.
      # stable-small = bin/ entries only, built from the stable channel we run.
      dbPkgs = import inputs.nix-index-database {inherit pkgs;};
      nixIndex = dbPkgs.nix-index-with-stable-small-db;
    in {
      programs.nix-index = {
        enable = true;
        package = nixIndex;
        # Upstream handler suggests nix-env -iA / nix-shell; ours points to comma instead
        enableZshIntegration = false;
        enableBashIntegration = false;
      };

      home.packages = [
        (pkgs.callPackage "${inputs.nix-index-database}/comma-wrapper.nix" {
          nix-index-database = dbPkgs.nix-index-stable-small-database;
        })
      ];

      programs.zsh.initContent = ''
        command_not_found_handler() {
          # Plain error in pipes and scripts, like the upstream handler
          [[ -t 1 ]] || { print -u2 "zsh: command not found: $1"; return 127 }
          local -a pkgs
          pkgs=(''${(f)"$(${lib.getExe nixIndex} --minimal --no-group --type x --type s --whole-name --at-root "/bin/$1")"})
          if (( ! $#pkgs )); then
            print -u2 "zsh: command not found: $1"
            return 127
          fi
          pkgs=(''${pkgs%.out})
          print -u2 "$1 n'est pas installé — fourni par : ''${(j:, :)pkgs}"
          print -u2 "  → , $*"
          return 127
        }
      '';
    };
  };
}
