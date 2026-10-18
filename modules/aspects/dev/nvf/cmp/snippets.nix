_: {
  den.aspects.nvf.homeManager = {pkgs, ...}: let
    # Custom snippets live as plain text files in _snippets/, split by format:
    #   snipmate/*.snippets  -> declarative SnipMate (loaded from `snippets/`)
    #   lua/*.lua            -> programmatic LuaSnip (loaded from `luasnippets/`)
    snippetsSrc = builtins.path {
      name = "nvf-snippets-src";
      path = ./_snippets;
    };

    customSnippets = pkgs.runCommandLocal "nvf-custom-snippets" {} ''
      mkdir -p $out/snippets $out/luasnippets $out/syntax $out/ftdetect
      for f in ${snippetsSrc}/snipmate/*.snippets; do
        [ -e "$f" ] && cp "$f" $out/snippets/
      done
      for f in ${snippetsSrc}/lua/*.lua; do
        [ -e "$f" ] && cp "$f" $out/luasnippets/
      done

      # Filetype detection and structural highlighting for .snippets files.
      cp ${snippetsSrc}/snipmate/highlight/syntax.vim $out/syntax/snippets.vim
      cp ${snippetsSrc}/snipmate/highlight/ftdetect.vim $out/ftdetect/snippets.vim
    '';
  in {
    programs.nvf.settings.vim = {
      startPlugins = [customSnippets];
      snippets.luasnip = {
        enable = true;
        loaders = ''
          require('luasnip.loaders.from_snipmate').lazy_load()
          require('luasnip.loaders.from_lua').lazy_load()
        '';
      };
    };
  };
}
