_: {
  perSystem = {pkgs, ...}: {
    # Tooling for pre-commit hooks (language: system) and CI
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
