_: {
  den.aspects.yoann.homeManager = {
    config,
    lib,
    flakePath,
    ...
  }: let
    # Out-of-store links: editable live, by hand and by Claude Code itself
    claudeFiles = "${flakePath}/modules/users/yoann/claude";
    link = path: config.lib.file.mkOutOfStoreSymlink "${claudeFiles}/${path}";
    # In-store path for agentsDir/hooksDir: the HM module readDirs them at eval time,
    # which pure mode forbids on absolute paths
    claudeFilesStore = ./.;
    # ~/.claude/agents is global scope: Claude Code does not walk up parents for .claude/agents
    agents = ".claude/agents";
  in {
    # Direct link, not home.file: /config refuses to write when the link goes through /nix/store
    home.activation.claudeSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
      run ln -sfn ${claudeFiles}/settings.json $HOME/.claude/settings.json
    '';

    home.file = {
      ".claude/CLAUDE.md".source = link "CLAUDE.md";
      "Projets/CLAUDE.md".source = link "workspace/CLAUDE.md";
      "${agents}/factcheck.md".source = link "workspace/factcheck.md";
      "${agents}/obsidian.md".source = link "workspace/obsidian.md";
      "${agents}/opentofu.md".source = link "workspace/opentofu.md";
      "${agents}/ansible.md".source = link "workspace/ansible.md";
      "${agents}/swarm.md".source = link "workspace/swarm.md";
      "${agents}/packer.md".source = link "workspace/packer.md";
      "${agents}/infra-reviewer.md".source = link "workspace/infra-reviewer.md";
      "${agents}/nixos.md".source = link "workspace/nixos.md";
    };

    programs.claude-code = {
      agentsDir = "${claudeFilesStore}/agents";
      hooksDir = "${claudeFilesStore}/hooks";
    };
  };
}
