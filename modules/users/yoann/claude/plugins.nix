_: {
  den.aspects.yoann.homeManager = {pkgs, ...}: let
    official = pkgs.fetchFromGitHub {
      owner = "anthropics";
      repo = "claude-plugins-official";
      rev = "205b6e0b30366a969412d9aab7b99bea99d58db1";
      hash = "sha256-0iZO5ZS0BO0LKkCDxwk+H07w/re7+w84X17h3GH23eM=";
    };
  in {
    programs.claude-code.plugins = map (p: "${official}/plugins/${p}") [
      "claude-md-management"
      "explanatory-output-style"
      "learning-output-style"
      "commit-commands"
      "code-review"
      "pr-review-toolkit"
      "security-guidance"
      "skill-creator"
      "hookify"
      "pyright-lsp"
      "typescript-lsp"
      "gopls-lsp"
    ];
  };
}
