_: {
  den.aspects.dev.homeManager = {
    flakePath,
    pkgs,
    ...
  }: {
    programs.zed-editor = {
      enable = true;
      mutableUserKeymaps = true;
      enableMcpIntegration = true;
      mutableUserSettings = true;
      mutableUserTasks = true;
      # NOTE: extensions required for languages with no native Zed support
      extensions = ["opentofu" "dockerfile" "ansible" "helm"];
      userSettings = {
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        session.trust_all_worktrees = true;
        theme = "Noctalia Dark";
        ui_font_family = "JetBrainsMono Nerd Font";
        ui_font_size = 15.0;
        ui_font_weight = 200.0;
        icon_theme = "Icons modern material (Dark)";
        buffer_font_family = "JetBrainsMonoNL Nerd Font";
        buffer_font_size = 16.0;
        buffer_font_weight = 500.0;
        buffer_line_height = "comfortable";
        cursor_blink = false;
        rounded_selection = true;
        vim_mode = true;
        vim = {
          toggle_relative_line_numbers = true;
          use_smartcase_find = true;
          use_system_clipboard = "always";
        };
        autosave.after_delay.milliseconds = 1000;
        which_key.enabled = true;
        scroll_beyond_last_line = "vertical_scroll_margin";
        sticky_scroll.enabled = true;
        show_signature_help_after_edits = true;
        auto_signature_help = true;
        drag_and_drop_selection.enabled = false;
        relative_line_numbers = "enabled";
        minimap.show = "auto";
        soft_wrap = "editor_width";
        colorize_brackets = true;
        inlay_hints = {
          show_background = true;
          enabled = true;
        };
        show_whitespaces = "boundary";
        indent_guides = {
          line_width = 2;
          active_line_width = 2;
          background_coloring = "disabled";
          coloring = "indent_aware";
        };
        lsp = {
          nixd = {
            binary.path = "${pkgs.nixd}/bin/nixd";
            settings.nixd.options = {
              nixos.expr = "(builtins.getFlake \"${flakePath}\").nixosConfigurations.laptop.options";
              home-manager.expr = "(builtins.getFlake \"${flakePath}\").nixosConfigurations.laptop.options.home-manager.users.yoann";
            };
          };
          ruff.binary = {
            path = "${pkgs.ruff}/bin/ruff";
            arguments = ["server"];
          };
          basedpyright.binary = {
            path = "${pkgs.basedpyright}/bin/basedpyright-langserver";
            arguments = ["--stdio"];
          };
          tofu-ls.binary = {
            path = "${pkgs.tofu-ls}/bin/tofu-ls";
            arguments = ["serve"];
          };
          yaml-language-server.binary = {
            path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
            arguments = ["--stdio"];
          };
          bash-language-server.binary = {
            path = "${pkgs.bash-language-server}/bin/bash-language-server";
            arguments = ["start"];
          };
          docker-language-server.binary = {
            path = "${pkgs.docker-language-server}/bin/docker-language-server";
            arguments = ["start" "--stdio"];
          };
          ansible-language-server.binary = {
            path = "${pkgs.ansible-language-server}/bin/ansible-language-server";
            arguments = ["--stdio"];
          };
          helm.binary = {
            path = "${pkgs.helm-ls}/bin/helm_ls";
            arguments = ["serve"];
          };
        };
        file_types = {
          OpenTofu = ["*.tf" "*.tfvars"];
          Ansible = [
            "**.ansible.yml"
            "**.ansible.yaml"
            "**/defaults/*.yml"
            "**/defaults/*.yaml"
            "**/meta/*.yml"
            "**/meta/*.yaml"
            "**/tasks/*.yml"
            "**/tasks/*.yaml"
            "**/handlers/*.yml"
            "**/handlers/*.yaml"
            "**/group_vars/*.yml"
            "**/group_vars/*.yaml"
            "**/host_vars/*.yml"
            "**/host_vars/*.yaml"
            "**/playbooks/*.yml"
            "**/playbooks/*.yaml"
            "**playbook*.yml"
            "**playbook*.yaml"
          ];
          Helm = [
            "**/templates/**/*.tpl"
            "**/templates/**/*.yaml"
            "**/templates/**/*.yml"
            "**/helmfile.d/**/*.yaml"
            "**/helmfile.d/**/*.yml"
            "**/values*.yaml"
          ];
        };
        languages = {
          Nix = {
            language_servers = ["nixd"];
            formatter.external = {
              command = "alejandra";
              arguments = ["-"];
            };
          };
          Python = {
            language_servers = ["ruff" "basedpyright"];
            formatter.language_server.name = "ruff";
          };
          OpenTofu = {
            language_servers = ["tofu-ls"];
            formatter.external = {
              command = "${pkgs.opentofu}/bin/tofu";
              arguments = ["fmt" "-no-color" "-"];
            };
          };
          YAML.language_servers = ["yaml-language-server"];
          Bash.language_servers = ["bash-language-server"];
          Dockerfile.language_servers = ["docker-language-server"];
          Ansible.language_servers = ["ansible-language-server"];
          Helm.language_servers = ["helm"];
        };
        diagnostics = {
          button = true;
          inline = {
            min_column = 1;
            padding = 10;
            enabled = true;
          };
        };
        completions.lsp_insert_mode = "replace";
        document_symbols = "on";
        document_folding_ranges = "on";
        semantic_tokens = "combined";
        close_on_file_delete = true;
        use_smartcase_search = true;
        search = {
          button = true;
          case_sensitive = true;
          whole_word = true;
        };
        tab_bar = {
          show_pinned_tabs_in_separate_row = true;
          show_nav_history_buttons = false;
        };
        tabs.file_icons = true;
        status_bar = {
          cursor_position_button = true;
          active_language_button = true;
        };
        project_panel = {
          sort_mode = "files_first";
          bold_folder_labels = true;
          auto_fold_dirs = false;
          indent_size = 25.0;
          default_width = 350.0;
          dock = "left";
          button = true;
        };
        outline_panel = {
          indent_size = 25.0;
          default_width = 350.0;
        };
        active_pane_modifiers = {
          border_size = 1.0;
          inactive_opacity = 0.8;
        };
        window_decorations = "client";
        centered_layout = {
          right_padding = 0.2;
          left_padding = 0.2;
        };
        collaboration_panel.button = false;
        notification_panel.default_width = 350.0;
        git_panel = {
          dock = "right";
          default_width = 350.0;
          tree_view = true;
          collapse_untracked_diff = false;
          sort_by_path = false;
          status_style = "icon";
        };
        agent = {
          default_profile = "ask";
          default_model = {
            provider = "google";
            model = "gemini-2.5-flash";
            enable_thinking = true;
          };
          single_file_review = true;
          default_height = 500.0;
          dock = "bottom";
          favorite_models = [];
          model_parameters = [];
        };
        context_servers = {};
        terminal = {
          default_height = 400.0;
          copy_on_select = true;
          cursor_shape = "bar";
        };
      };
    };
  };
}
