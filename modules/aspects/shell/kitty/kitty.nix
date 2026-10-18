{den, ...}: {
  den.aspects.shell = {
    includes = with den; [
      aspects.kitty
    ];
    homeManager = {
      config,
      flakePath,
      ...
    }: {
      programs.kitty = {
        enable = true;
        enableGitIntegration = true;
        font = {
          name = "JetBrainsMono NF";
          size = 12;
        };
        keybindings = {
          # Maximise/restore the current window (stack layout)
          "kitty_mod+m" = "toggle_layout stack";
          # New window, same cwd (and same host/dir if source is an SSH session)
          "f1" = "new_window_with_cwd";
          "f12" = "close_session";
          "f11" = "save_as_session --use-foreground-process --base-dir ~/.config/kitty/sessions";
          # New tab, same cwd, joins the active session if any
          "ctrl+shift+t" = "new_tab_with_cwd";
          "f4" = "launch --location=split";
          "f5" = "launch --location=hsplit";
          "f6" = "launch --location=vsplit";
        };

        settings = {
          cursor_shape = "block";
          cursor_blink_interval = 0;
          cursor_shape_unfocused = "hollow";
          cursor_trail = 1;
          cursor_trail_decay = "0.18 0.5";
          cursor_trail_start_threshold = 0;
          cursor_trail_color = "none";

          scrollback_lines = 5000;
          scrollbar = "never";
          progress_bar = "top";
          scrollback_pager = "nvim --cmd 'set eventignore=FileType' +'nnoremap q ZQ' +'call nvim_open_term(0, {})' +'set nomodified nolist' +'$' -";

          url_style = "dashed";
          detect_urls = true;
          underline_hyperlinks = "always";
          copy_on_select = "clipboard";
          clear_selection_on_clipboard_loss = true;
          paste_actions = "quote-urls-at-prompt,replace-dangerous-control-codes";
          strip_trailing_spaces = "smart";

          enable_audio_bell = false;
          # Must be > 0 for the bell-in-window shader event
          visual_bell_duration = "0.01";
          bell_on_tab = "";
          notify_on_cmd_finish = "unfocused 15";

          remember_window_size = false;

          window_border_width = "2pt";
          window_padding_width = 2;
          draw_minimal_borders = "true";
          confirm_os_window_close = 2;

          # tab_bar.py draws a session pill and process-named tabs
          tab_bar_style = "custom";
          tab_bar_edge = "top";
          tab_bar_min_tabs = 1;
          tab_powerline_style = "round";
          # Title is computed in tab_bar.py (icon + foreground process)
          tab_title_template = "{title}";
          tab_bar_filter = "session:~";

          dynamic_background_opacity = true;
          background_opacity = "1.0";

          # Order matters: dim after background
          custom_shaders = "bg-texture matrix-trail dim-inactive tab-slide bell-pulse";

          allow_remote_control = "yes";
          listen_on = "unix:@mykitty";
          # TODO: set startup_session once sessions are usable
          allow_cloning = "ask";
        };

        extraConfig = ''
          # Dynamic theming with noctalia
          include themes/noctalia.conf

          # Better underline, default was very thin on my screen
          modify_font underline_position 3
          modify_font underline_thickness 125%

          # Seamless split navigation with nvim (smart-splits.nvim).
          map ctrl+j neighboring_window down
          map ctrl+k neighboring_window up
          map ctrl+h neighboring_window left
          map ctrl+l neighboring_window right
          map --when-focus-on var:IS_NVIM ctrl+j
          map --when-focus-on var:IS_NVIM ctrl+k
          map --when-focus-on var:IS_NVIM ctrl+h
          map --when-focus-on var:IS_NVIM ctrl+l

          # Seamless split resizing with nvim (smart-splits.nvim resize_*, amount=3).
          map alt+shift+j kitten relative_resize.py down  3
          map alt+shift+k kitten relative_resize.py up    3
          map alt+shift+h kitten relative_resize.py left  3
          map alt+shift+l kitten relative_resize.py right 3
          map --when-focus-on var:IS_NVIM alt+shift+j
          map --when-focus-on var:IS_NVIM alt+shift+k
          map --when-focus-on var:IS_NVIM alt+shift+h
          map --when-focus-on var:IS_NVIM alt+shift+l
        '';
      };

      xdg.configFile = {
        # Out-of-store so kitty can write session files (save_as_session)
        sessions = {
          source =
            config.lib.file.mkOutOfStoreSymlink
            "${flakePath}/modules/aspects/shell/kitty/sessions";
          target = "kitty/sessions";
        };

        # Out-of-store to tweak shaders without a rebuild
        shaders = {
          source =
            config.lib.file.mkOutOfStoreSymlink
            "${flakePath}/modules/aspects/shell/kitty/shaders";
          target = "kitty/shaders";
        };

        # Seamless navigation between nvim and kitty
        navigation = {
          source = ./scripts/neighboring_window.py;
          target = "kitty/neighboring_window.py";
        };

        # Kitten required by smart-splits.nvim for resize_*
        resize = {
          source = ./scripts/relative_resize.py;
          target = "kitty/relative_resize.py";
        };

        tabBar = {
          source = ./scripts/tab_bar.py;
          target = "kitty/tab_bar.py";
        };
      };
    };
  };
}
