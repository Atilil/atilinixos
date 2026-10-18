_: {
  den.aspects.ai.homeManager = {pkgs, ...}: let
    # claude-hud statusline, rebuilt from src at a reviewed commit (SkillSpector + manual review).
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
    # mattpocock/skills at a reviewed commit (SkillSpector + manual review).
    mpSkills = pkgs.fetchFromGitHub {
      owner = "mattpocock";
      repo = "skills";
      rev = "49dd158d1076134a641b33efb035946536778336";
      hash = "sha256-NljCSZNI3sZ+vbCw7pRdrwR7try4BxOFp4gdjuWYtzs=";
    };
    # clewisdev pii-check, patched for NixOS (nix run instead of curl/sudo installs).
    piiCheck =
      pkgs.runCommand "skill-pii-check" {
        src = pkgs.fetchFromGitHub {
          owner = "clewisdev";
          repo = "skills";
          rev = "bd55e7b36dbcc6b7204d88a9f7243b048dfcdabb";
          hash = "sha256-81a9oIzCevuPqHgFoaEHVpxJKym/dhSGwfPNmQEFDrw=";
        };
      } ''
        cp -r $src/pii-check $out && chmod -R u+w $out
        patch -d $out -p1 < ${./_skills/pii-check-nixos.patch}
      '';
    # PostHog writing-code-comments (MIT outside ee/).
    commentsSkill = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/PostHog/posthog/ffd69dad6b7011bfc52c6e99ed0b25cb2b0f20d5/.agents/skills/writing-code-comments/SKILL.md";
      hash = "sha256-SEcuGoQyeqU+LFEAKLG/ryLEEccFZ1NhlOkYajcdNkg=";
    };
    # PreToolUse guard: block 4+ consecutive `#` comment lines in hash-comment languages.
    commentWallGuard = pkgs.writers.writePython3 "comment-wall-guard" {} ''
      import json
      import re
      import sys

      EXTS = (".nix", ".sh", ".bash", ".zsh", ".py", ".yml", ".yaml",
              ".tf", ".tfvars", ".hcl", ".toml", ".conf", ".cfg")
      WALL = re.compile(r"(?m)(^[ \t]*#(?!!).*\n){4,}")

      data = json.load(sys.stdin)
      inp = data.get("tool_input", {})
      path = inp.get("file_path", "")
      if not path.endswith(EXTS) and not path.endswith("Dockerfile"):
          sys.exit(0)
      texts = [inp.get("content", ""), inp.get("new_string", "")]
      texts += [e.get("new_string", "") for e in inp.get("edits", [])]
      if any(WALL.search(t + "\n") for t in texts if t):
          print(
              "Comment block of 4+ lines: one short English line per comment "
              "(3 max for a real trap); details go in the commit message.",
              file=sys.stderr,
          )
          sys.exit(2)
    '';
  in {
    home.packages = [pkgs.python3];

    # teach writes its records in the current dir: only in the learning repo.
    home.file."Projets/learning/.claude/skills/teach".source = "${mpSkills}/skills/productivity/teach";

    programs.claude-code = {
      enable = true;
      package = pkgs.unstable.claude-code;
      enableMcpIntegration = true;
      commands = {};
      # User-invoked (grill-me, handoff, retro) plus the skills they call.
      skills = {
        grill-me = "${mpSkills}/skills/productivity/grill-me";
        grilling = "${mpSkills}/skills/productivity/grilling";
        handoff = "${mpSkills}/skills/productivity/handoff";
        retro = "${mpSkills}/skills/engineering/retro";
        writing-for-agents = "${mpSkills}/skills/productivity/writing-for-agents";
        pii-check = piiCheck;
        writing-code-comments = commentsSkill;
      };
      rules = {};
      outputStyles = {};
      lspServers = {
        nix = {
          command = "${pkgs.nixd}/bin/nixd";
          extensionToLanguage.".nix" = "nix";
        };
        yaml = {
          command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
          args = ["--stdio"];
          extensionToLanguage = {
            ".yaml" = "yaml";
            ".yml" = "yaml";
          };
        };
        terraform = {
          command = "${pkgs.terraform-ls}/bin/terraform-ls";
          args = ["serve"];
          extensionToLanguage = {
            ".tf" = "terraform";
            ".tfvars" = "terraform";
          };
        };
        bash = {
          command = "${pkgs.bash-language-server}/bin/bash-language-server";
          args = ["start"];
          extensionToLanguage = {
            ".sh" = "shellscript";
            ".bash" = "shellscript";
          };
        };
        markdown = {
          command = "${pkgs.marksman}/bin/marksman";
          args = ["server"];
          extensionToLanguage = {
            ".md" = "markdown";
            ".markdown" = "markdown";
          };
        };
        toml = {
          command = "${pkgs.taplo}/bin/taplo";
          args = ["lsp" "stdio"];
          extensionToLanguage.".toml" = "toml";
        };
      };
      settings = {
        hooks.PreToolUse = [
          {
            matcher = "Write|Edit|MultiEdit";
            hooks = [
              {
                type = "command";
                command = "${commentWallGuard}";
              }
            ];
          }
        ];
        language = "French";
        effortLevel = "high";
        awaySummaryEnabled = false;
        includeCoAuthoredBy = false;
        theme = "dark";
        editorMode = "vim";
        outputStyle = "Explanatory";
        cleanupPeriodDays = 14;
        statusLine = {
          type = "command";
          command = "${pkgs.nodejs}/bin/node ${claude-hud}/lib/claude-hud/dist/index.js";
          padding = 0;
        };
      };
    };
  };
}
