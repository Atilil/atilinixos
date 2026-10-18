{
  pkgs,
  config,
  flakePath,
  ...
}: let
  # Must be ~/.claude/agents (global scope): Claude Code does not walk up parent dirs to find .claude/agents/.
  homeFile = ".claude/agents";
  # In-store Nix path for agentsDir/hooksDir: claude-code's HM module does a readDir at eval time,
  # which is forbidden on absolute paths in pure mode.
  claudeFilesStore = ../../config/_ai-tools/claude;
  # Absolute out-of-store path so workspace files stay mutable (Claude edits its own context,
  # the repo reflects it immediately).
  claudeFiles = "${flakePath}/modules/users/yoann/config/_ai-tools/claude";
  link = path: config.lib.file.mkOutOfStoreSymlink "${claudeFiles}/${path}";
  githubMcpWrapper = pkgs.writeShellScript "github-mcp-wrapper" ''
    export GITHUB_PERSONAL_ACCESS_TOKEN="$(cat /run/secrets/github_token_yoann)"
    exec ${pkgs.github-mcp-server}/bin/github-mcp-server stdio
  '';
  plugins = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-plugins-official";
    rev = "205b6e0b30366a969412d9aab7b99bea99d58db1";
    hash = "sha256-0iZO5ZS0BO0LKkCDxwk+H07w/re7+w84X17h3GH23eM=";
  };
in {
  home.file = {
    "${homeFile}/factcheck.md".source = link "workspace/factcheck.md";
    "${homeFile}/obsidian.md".source = link "workspace/obsidian.md";
    "${homeFile}/opentofu.md".source = link "workspace/opentofu.md";
    "${homeFile}/ansible.md".source = link "workspace/ansible.md";
    "${homeFile}/swarm.md".source = link "workspace/swarm.md";
    "${homeFile}/packer.md".source = link "workspace/packer.md";
    "${homeFile}/infra-reviewer.md".source = link "workspace/infra-reviewer.md";
    "${homeFile}/nixos.md".source = link "workspace/nixos.md";
    "Projets/CLAUDE.md".source = link "workspace/CLAUDE.md";
  };
  programs.claude-code = {
    agentsDir = "${claudeFilesStore}/agents";
    hooksDir = "${claudeFilesStore}/hooks";
    mcpServers.github.command = "${githubMcpWrapper}";
    plugins = [
      "${plugins}/plugins/claude-md-management"
      "${plugins}/plugins/explanatory-output-style"
      "${plugins}/plugins/learning-output-style"
      "${plugins}/plugins/commit-commands"
      "${plugins}/plugins/code-review"
      "${plugins}/plugins/pr-review-toolkit"
      "${plugins}/plugins/security-guidance"
      "${plugins}/plugins/skill-creator"
      "${plugins}/plugins/hookify"
      "${plugins}/plugins/pyright-lsp"
      "${plugins}/plugins/typescript-lsp"
      "${plugins}/plugins/gopls-lsp"
    ];
    context = ''
      # Profil

      Ancien technicien helpdesk de 40 ans en reconversion DevOps.
      Je souhaiter monter en compétences sur les domaines devops en géneral
      J'aime l'automatisation, apprendre de nouveau concept,
      explorer de nouveaux outils et le homelabing

      Objectif long terme : devenir ingénieur.

      # Comment me parler

      - Toujours en français.
      - Pédagogique: je souhaite apprendre, si je n'ai pas compris un concept, élabore.
      - Ne suppose rien: si j'ai probablement l'info (mon setup, mes choix), demande-moi; sinon vérifie/cherche toi-même.
      - Si tu n'es pas sûr, dis-le.
      - Si je dis quelque chose de faux, corrige-moi franchement - mais vérifie ta source avant de me contredire
      - Suggestion pertinentes bienvenues, même non sollicités, tant qu'elles apportent une vraie valeur

      # Garde-fous techniques

      - Avant de modifier un fichier sensible, vérifie d'abord.
      - Pas de modification destructive sans validation explicite.
    '';
    settings = {
      hooks = {
        PreToolUse = [
          {
            matcher = "Edit|Write";
            hooks = [
              {
                type = "command";
                command = "${config.home.homeDirectory}/.claude/hooks/block-flake-nix.sh";
              }
            ];
          }
        ];
        PostToolUse = [
          {
            matcher = "Edit|Write";
            hooks = [
              {
                type = "command";
                command = "${config.home.homeDirectory}/.claude/hooks/alejandra-format.sh";
              }
            ];
          }
        ];
      };
      permissions = {
        defaultMode = "default";
        allow = [
          "WebFetch(domain:flake.parts)"
          "WebFetch(domain:nixos.org)"
          "WebFetch(domain:wiki.nixos.org)"
          "WebFetch(domain:search.nixos.org)"
          "WebFetch(domain:discourse.nixos.org)"
          "WebFetch(domain:home-manager-options.extranix.com)"
          "WebFetch(domain:noogle.dev)"
          "WebFetch(domain:nix.dev)"
          "WebFetch(domain:talks.nixcon.org)"
          "WebFetch(domain:vic.github.io)"
          "WebFetch(domain:import-tree.oeiuwq.com)"
          "WebFetch(domain:code.claude.com)"
          "WebFetch(domain:docs.claude.com)"
          "WebFetch(domain:docs.anthropic.com)"
          "WebFetch(domain:github.com)"
          "WebFetch(domain:gitlab.com)"
          "WebFetch(domain:raw.githubusercontent.com)"
          "WebFetch(domain:api.github.com)"
          "WebFetch(domain:gist.github.com)"
          "WebSearch"
          "Bash(obsidian-cli:*)"
        ];
        ask = [
          "Bash(git push:*)"
          "Bash(git push --force:*)"
          "Bash(git reset --hard:*)"
          "Bash(rm -rf:*)"
          "Bash(gh pr create:*)"
          "Bash(glab mr create:*)"
          "Bash(nh os boot:*)"
          "Bash(sudo:*)"
        ];
        deny = [
          "Read(/home/yoann/.config/sops/age/keys.txt)"
          "Read(/home/yoann/.ssh/id_*)"
          "Read(/home/yoann/.bitwarden-ssh-agent.sock)"
          "Read(**/secrets.yaml)"
          "Edit(/etc/**)"
        ];
      };
    };
  };
}
