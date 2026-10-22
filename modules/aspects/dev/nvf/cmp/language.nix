_: {
  den.aspects.nvf.homeManager = _: {
    programs.nvf.settings.vim.languages = {
      # Global feature toggles, applied to every enabled language below
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      enableDAP = true;

      nix = {
        enable = true;
        lsp.servers = ["nil"];
      };

      markdown = {
        enable = true;
        # render-markdown: in-buffer rendering of headings, tables and checkboxes
        extensions.render-markdown-nvim = {
          enable = true;
          setupOpts = {
            header = {
              position = "inline";
              border = true;
              border_virtual = true;
            };
            paragraph.indent = 2;
            code = {
              width = "block";
              min_width = 45;
            };
            pipe_table = {
              preset = "round";
              cell = "trimmed";
            };
            sign.enabled = false;
          };
        };
      };

      python = {
        enable = true;
        format.type = ["ruff"];
        # ruff lints and formats, basedpyright does types and navigation; they run together
        # (see basedpyright.settings.typeCheckingMode in lsp.nix)
        lsp.servers = ["ruff" "basedpyright"];
        # ruff already lints; skip nvim-lint's mypy
        extraDiagnostics.enable = false;
      };

      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };

      terraform = {
        enable = true;
        lsp.servers = ["tofu-ls"];
        format.type = ["opentofu"];
      };

      yaml = {
        enable = true;
        # gitlab-ci-ls covers .gitlab-ci.yml
        lsp.servers = ["yaml-language-server" "gitlab-ci-ls"];
      };

      # Ansible .j2 templates (jinja-lsp)
      jinja.enable = true;

      bash = {
        enable = true;
        # bash-language-server already bridges shellcheck
        extraDiagnostics.enable = false;
      };
      docker.enable = true;
      hcl.enable = true;
      helm.enable = true;
      json.enable = true;
      toml.enable = true;
      lua.enable = true;
      sql.enable = true;
      css.enable = true;
      html.enable = true;
      go.enable = true;

      # Explicitly off: already the nvf default, kept for visibility
      openscad.enable = false;
      arduino.enable = false;
      assembly.enable = false;
      astro.enable = false;
      nu.enable = false;
      csharp.enable = false;
      julia.enable = false;
      vala.enable = false;
      scala.enable = false;
      r.enable = false;
      gleam.enable = false;
      glsl.enable = false;
      dart.enable = false;
      ocaml.enable = false;
      elixir.enable = false;
      haskell.enable = false;
      ruby.enable = false;
      fsharp.enable = false;
      just.enable = false;
      make.enable = false;
      qml.enable = false;
      svelte.enable = false;
      vue.enable = false;
      liquid.enable = false;
      tera.enable = false;
      twig.enable = false;
      gettext.enable = false;
      fluent.enable = false;
      jq.enable = false;
    };
  };
}
