_: {
  den.aspects.ai.homeManager = {pkgs, ...}: {
    programs.mcp = {
      enable = true;
      servers = {
        nixos.command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        terraform.command = "${pkgs.terraform-mcp-server}/bin/terraform-mcp-server";
        sequential-thinking.command = "${pkgs.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking";
        memory.command = "${pkgs.mcp-server-memory}/bin/mcp-server-memory";
      };
    };
  };
}
