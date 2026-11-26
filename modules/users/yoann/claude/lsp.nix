_: {
  den.aspects.yoann.homeManager = {pkgs, ...}: {
    programs.claude-code.lspServers = {
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
  };
}
