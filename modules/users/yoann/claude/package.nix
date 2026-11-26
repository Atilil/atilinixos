_: {
  den.aspects.yoann.homeManager = {pkgs, ...}: let
    # Read-only token for gh inside Claude Code
    claudeWithGhToken = pkgs.symlinkJoin {
      name = "claude-code-gh-token";
      paths = [pkgs.unstable.claude-code];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/claude \
          --run 'if [ -r /run/secrets/github_classic_token_yoann ]; then export GH_TOKEN="$(cat /run/secrets/github_classic_token_yoann)"; else export GH_TOKEN=secret-missing; fi'
      '';
      inherit (pkgs.unstable.claude-code) meta;
    };
    githubMcpWrapper = pkgs.writeShellScript "github-mcp-wrapper" ''
      export GITHUB_PERSONAL_ACCESS_TOKEN="$(cat /run/secrets/github_token_yoann)"
      exec ${pkgs.github-mcp-server}/bin/github-mcp-server stdio
    '';
  in {
    programs.claude-code = {
      package = claudeWithGhToken;
      mcpServers.github.command = "${githubMcpWrapper}";
    };
  };
}
