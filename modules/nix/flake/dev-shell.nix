_: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        pre-commit
        alejandra
        deadnix
        statix
        forgejo-runner
        gitleaks
        shellcheck
      ];
    };
  };
}
