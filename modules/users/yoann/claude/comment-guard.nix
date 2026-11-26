_: {
  den.aspects.yoann.homeManager = {pkgs, ...}: {
    # PreToolUse hook (see settings.json): block 4+ consecutive `#` comment lines
    home.packages = [
      (pkgs.writers.writePython3Bin "claude-comment-guard" {} ''
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
      '')
    ];
  };
}
