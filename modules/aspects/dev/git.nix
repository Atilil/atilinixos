_: {
  den.aspects.dev = {
    homeManager = {
      config,
      pkgs,
      ...
    }: let
      forgeSigningKey = config.userInfo.publicKeys.forgejo;
      allowedSigners = "${config.xdg.configHome}/git/allowed_signers";

      dispatchToRepo = {
        stage,
        preCommitArgs ? "",
      }: ''
        if [ -f "$(git rev-parse --show-toplevel)/.pre-commit-config.yaml" ]; then
          PATH="${pkgs.git}/bin:$PATH" exec ${pkgs.pre-commit}/bin/pre-commit run --hook-stage ${stage} ${preCommitArgs}
        fi

        local_hook="$(git rev-parse --git-common-dir)/hooks/${stage}"
        if [ -x "$local_hook" ]; then
          exec "$local_hook" "$@"
        fi
      '';

      commitTemplate = pkgs.writeText "git-commit-template" ''

        # Conventional Commits : type(scope optionnel): description
        # La description est en anglais, à l'impératif, sans point final.
        #
        #   feat      nouvelle fonctionnalité
        #   fix       correction de bug
        #   refactor  réécriture sans changement de comportement
        #   docs      documentation uniquement
        #   ci        pipelines CI/CD
        #   build     système de build, dépendances, packaging
        #   chore     maintenance qui ne touche pas au code applicatif
        #   test      ajout ou correction de tests
        #   perf      amélioration de performance
        #   revert    annulation d'un commit précédent
        #
        # Exemples :
        #   feat(proxmox): read API token from OpenBao
        #   chore(deps): bump pre-commit-hooks
      '';
    in {
      xdg.configFile."git/allowed_signers".text = ''
        ${config.userInfo.emails.primary} namespaces="git" ${forgeSigningKey}
      '';

      programs = {
        delta = {
          enable = true;
          enableGitIntegration = true;
        };
        git = {
          enable = true;
          signing = {
            key = "258F8A6F96D761EE";
            signByDefault = false;
          };
          includes =
            [
              {
                condition = "gitdir:~/Projets/quickdata/";
                contents.commit.gpgsign = true;
              }
            ]
            ++ map (url: {
              condition = "hasconfig:remote.*.url:${url}";
              contents = {
                gpg.format = "ssh";
                gpg.ssh.allowedSignersFile = allowedSigners;
                user.signingkey = "key::${forgeSigningKey}";
                commit.gpgsign = true;
                tag.gpgsign = true;
              };
            }) [
              "git@forge.macopla.com:*/**"
              "ssh://git@forge.macopla.com*/**"
              "https://forge.macopla.com/**"
            ];
          # Safety net for repos without their own .pre-commit-config.yaml: gitleaks, file size, conflict markers.
          # Opt out per repo with `git config hooks.skipGlobal true`.
          hooks.pre-commit = pkgs.writeShellScript "pre-commit" ''
            set -uo pipefail

            global_checks() {
              local fail=0
              local max_size=5242880 # 5 MiB

              ${pkgs.gitleaks}/bin/gitleaks git --staged --redact -v || fail=1

              while IFS= read -r -d "" file; do
                [ -f "$file" ] || continue

                size=$(${pkgs.coreutils}/bin/stat -c%s "$file")
                if [ "$size" -gt "$max_size" ]; then
                  echo "pre-commit: $file is $size bytes (limit: $max_size)" >&2
                  fail=1
                fi

                if ${pkgs.gnugrep}/bin/grep -lE '^(<{7}|={7}|>{7})( |$)' "$file" >/dev/null; then
                  echo "pre-commit: merge conflict markers found in $file" >&2
                  fail=1
                fi
              done < <(git diff --cached --name-only -z --diff-filter=ACM)

              return "$fail"
            }

            if [ -f "$(git rev-parse --show-toplevel)/.pre-commit-config.yaml" ]; then
              : # the repo's own hooks cover these checks, avoid running them twice
            elif [ "$(git config --bool hooks.skipGlobal)" = true ]; then
              echo "pre-commit: hooks.skipGlobal is set, skipping global checks" >&2
            else
              global_checks || exit 1
            fi

            ${dispatchToRepo {stage = "pre-commit";}}
          '';
          # No global message check: repos enforce the format through pre-commit's commit-msg stage.
          hooks.commit-msg = pkgs.writeShellScript "commit-msg" ''
            set -uo pipefail

            # Nothing global to skip here; the repo's own hooks still run, as in pre-commit.
            if [ "$(git config --bool hooks.skipGlobal)" = true ]; then
              echo "commit-msg: hooks.skipGlobal is set, no global checks to skip" >&2
            fi

            ${dispatchToRepo {
              stage = "commit-msg";
              preCommitArgs = ''--commit-msg-filename "$1"'';
            }}
          '';
          settings = {
            user.name = config.userInfo.names.gitName;
            user.email = config.userInfo.emails.primary;
            init.defaultBranch = "main";
            pull.rebase = true;
            rerere.enabled = true;
            push.autoSetupRemote = true;
            fetch.prune = true;
            diff.colorMoved = "default";
            commit.verbose = true;
            commit.template = "${commitTemplate}";
            branch.sort = "-committerdate";
          };
          ignores = [
            "*~"
            "*.swp"
            ".DS_Store"
            ".direnv"
          ];
        };
      };
    };
  };
}
