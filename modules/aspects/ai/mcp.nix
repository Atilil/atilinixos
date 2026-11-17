_: {
  den.aspects.ai.homeManager = {
    lib,
    pkgs,
    ...
  }: let
    # Non-hermetic test: asserts "Error" absent from an arbitrary /nix/store file, fixed in 3.x
    # https://github.com/utensils/mcp-nixos/issues/198
    mcp-nixos =
      if pkgs.mcp-nixos.version == "2.4.3"
      then
        pkgs.mcp-nixos.overridePythonAttrs (old: {
          disabledTests = (old.disabledTests or []) ++ ["test_read_text_file"];
        })
      else lib.warn "mcp.nix: mcp-nixos workaround obsolete (${pkgs.mcp-nixos.version}), remove it" pkgs.mcp-nixos;
  in {
    programs.mcp = {
      enable = true;
      servers = {
        nixos.command = "${mcp-nixos}/bin/mcp-nixos";
        terraform.command = "${pkgs.terraform-mcp-server}/bin/terraform-mcp-server";
        sequential-thinking.command = "${pkgs.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking";
        memory.command = "${pkgs.mcp-server-memory}/bin/mcp-server-memory";
      };
    };
  };
}
