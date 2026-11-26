_: {
  den.aspects.yoann.homeManager = {pkgs, ...}: let
    # Sources pinned at reviewed commits (SkillSpector + manual review)
    mpSkills = pkgs.fetchFromGitHub {
      owner = "mattpocock";
      repo = "skills";
      rev = "49dd158d1076134a641b33efb035946536778336";
      hash = "sha256-NljCSZNI3sZ+vbCw7pRdrwR7try4BxOFp4gdjuWYtzs=";
    };
    # clewisdev pii-check, patched for NixOS (nix run instead of curl/sudo installs)
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
        patch -d $out -p1 < ${./pii-check-nixos.patch}
      '';
    # PostHog writing-code-comments (MIT outside ee/)
    commentsSkill = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/PostHog/posthog/ffd69dad6b7011bfc52c6e99ed0b25cb2b0f20d5/.agents/skills/writing-code-comments/SKILL.md";
      hash = "sha256-SEcuGoQyeqU+LFEAKLG/ryLEEccFZ1NhlOkYajcdNkg=";
    };
  in {
    # teach writes its records in the current dir: only in the learning repo
    home.file."Projets/learning/.claude/skills/teach".source = "${mpSkills}/skills/productivity/teach";

    # User-invoked (grill-me, handoff, retro) plus the skills they call
    programs.claude-code.skills = {
      grill-me = "${mpSkills}/skills/productivity/grill-me";
      grilling = "${mpSkills}/skills/productivity/grilling";
      handoff = "${mpSkills}/skills/productivity/handoff";
      retro = "${mpSkills}/skills/engineering/retro";
      writing-for-agents = "${mpSkills}/skills/productivity/writing-for-agents";
      pii-check = piiCheck;
      writing-code-comments = commentsSkill;
    };
  };
}
