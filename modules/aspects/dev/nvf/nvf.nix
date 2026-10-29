{
  inputs,
  den,
  ...
}: {
  flake-file.inputs.nvf = {
    url = "github:NotAShelf/nvf";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  den.aspects.dev = {
    includes = with den; [
      aspects.nvf
    ];

    homeManager = {config, ...}: {
      imports = [inputs.nvf.homeManagerModules.default];

      programs.nvf = {
        enable = true;

        # Some plugins write files into the default nvim path
        settings.vim.additionalRuntimePaths = ["${config.home.homeDirectory}/.config/nvim"];

        settings.vim = {
          viAlias = true;
          # Defaults to true: would shadow the real vim from vim.nix
          vimAlias = false;

          # Experimental Lua loader, speeds up startup
          enableLuaLoader = true;

          syntaxHighlighting = true;

          searchCase = "smart";

          undoFile.enable = true;

          # Set enable = true to debug; level 16 is the most verbose
          debugMode = {
            enable = false;
            level = 16;
            logFile = "/tmp/nvf.log";
          };

          opts = {
            timeout = true;
            tm = 1000;

            nu = true;
            relativenumber = true;

            tabstop = 4;
            softtabstop = 4;
            shiftwidth = 4;
            expandtab = true;

            smartindent = true;
            preserveindent = true;
            autoindent = true;
            copyindent = true;
            backspace = "indent,eol,start";

            wrap = true;
            linebreak = true;
            breakindent = true;
            colorcolumn = "";

            inccommand = "split";
            splitbelow = true;
            splitright = true;

            # 999 keeps the cursor line vertically centered
            scrolloff = 999;

            autoread = true;

            cmdheight = 0;
            cursorline = true;
            cursorlineopt = "both";

            signcolumn = "yes:1";

            numberwidth = 1;

            fillchars = "eob: ";
            listchars = "trail:·";

            winborder = "none";

            # 99 opens every file fully unfolded (treesitter folds stay available)
            foldlevelstart = 99;
          };

          spellcheck = {
            enable = false;
            languages = ["en" "fr"];
          };

          clipboard = {
            enable = true;
            providers.wl-copy.enable = true;
            registers = "unnamedplus";
          };
        };
      };
    };
  };
}
