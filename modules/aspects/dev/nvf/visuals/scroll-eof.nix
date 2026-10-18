_: {
  den.aspects.nvf.homeManager = {pkgs, ...}: let
    scrollEOF-nvim = pkgs.vimUtils.buildVimPlugin {
      pname = "scrollEOF.nvim";
      version = "2025-09-14";
      src = pkgs.fetchFromGitHub {
        owner = "Aasim-A";
        repo = "scrollEOF.nvim";
        rev = "e462b9a07b8166c3e8011f1dcbc6bf68b67cd8d7";
        hash = "sha256-y7yOCRSGTtQcFyWVkGe3xQqstHZMQKayxtqkOVlZ4PM=";
      };
    };
  in {
    programs.nvf.settings.vim = {
      extraPlugins.scrollEOF-nvim = {
        package = scrollEOF-nvim;
        setup = "require('scrollEOF').setup {}";
      };
    };
  };
}
