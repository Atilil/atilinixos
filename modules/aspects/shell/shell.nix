_: {
  den.aspects.shell = {
    os = _: {
      environment.pathsToLink = ["/share/zsh"];
      programs.zsh.enable = true;
    };
    homeManager = {pkgs, ...}: let
      aliases = {
        ll = "eza -lh --header";
        lla = "eza -alh --header";
        ls = "eza";
        lt = "eza -T --level=2";
        lr = "eza -la --sort=modified --time-style=relative";
        cat = "bat";
        ale = "alejandra --exclude flake.nix $NH_OS_FLAKE";
        x = "exit";
      };
      abbr = {
        s = "kitten ssh";
        so = "nvim oil-ssh://";
        edit = "kitten edit-in-kitty";
        gs = "git status";
        ga = "git add .";
        gc = "git commit -m";
        gp = "git pull";
        gP = "git push";
        clone = "clone-in-kitty";
        clonetab = "clone-in-kitty --type=tab";
      };
    in {
      programs = {
        bash = {
          enable = true;
          shellAliases = aliases;
          historyControl = ["ignoredups" "ignorespace"];
        };
        zsh = {
          enable = true;
          autocd = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          shellAliases = aliases;
          zsh-abbr = {
            enable = true;
            abbreviations = abbr;
          };
          history = {
            append = true;
            expireDuplicatesFirst = true;
            findNoDups = true;
            ignoreAllDups = true;
          };
          setOptions = [
            "HIST_REDUCE_BLANKS"
            "INTERACTIVE_COMMENTS"
            "EXTENDED_GLOB"
            "AUTO_PUSHD"
            "PUSHD_IGNORE_DUPS"
            "PUSHD_SILENT"
          ];
          plugins = [
            {
              name = "fzf-tab";
              src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
              file = "fzf-tab.plugin.zsh";
            }
            {
              name = "bd";
              src = "${pkgs.zsh-bd}/share/zsh-bd";
              file = "bd.plugin.zsh";
            }
          ];
          initContent = ''
            autoload -U +X bashcompinit && bashcompinit
            complete -o nospace -C ${pkgs.openbao}/bin/bao bao
            complete -C aws_completer aws

            command -v just >/dev/null && eval "$(just --completions zsh)"

            # Populate LS_COLORS via GNU dircolors so the completion menu
            # colorizes files/directories by type (LS_COLORS is empty otherwise).
            # Must run before the `list-colors ''${(s.:.)LS_COLORS}` zstyle below.
            eval "$(dircolors -b)"

            zmodload zsh/complist
            setopt menucomplete

            # fish-like autosuggestions: complete from history and the completion engine
            ZSH_AUTOSUGGEST_STRATEGY=(history completion)

            # fish-like Up/Down: search history filtered by the prefix already typed
            autoload -U up-line-or-beginning-search down-line-or-beginning-search
            zle -N up-line-or-beginning-search
            zle -N down-line-or-beginning-search
            bindkey '^[[A' up-line-or-beginning-search
            bindkey '^[OA' up-line-or-beginning-search
            bindkey '^[[B' down-line-or-beginning-search
            bindkey '^[OB' down-line-or-beginning-search

            # edit-command-line to write complex command in text editor
            autoload -U edit-command-line
            zle -N edit-command-line
            bindkey '^X^E' edit-command-line

            zstyle ':completion:*'                    menu select=2 search

            bindkey -M menuselect '/'                 history-incremental-search-forward
            bindkey -M menuselect '?'                 history-incremental-search-backward

            zstyle ':completion:*'                    matcher-list \
                                                      'm:{[:lower:]-}={[:upper:]_}' \
                                                      'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
                                                      'r:|?=** m:{a-z\-}={A-Z\_}'
            zstyle ':completion:*:descriptions'       format '[%d]'
            zstyle ':completion:*:git-checkout:*'     sort false
            zstyle ':completion:*'                    completer _expand _complete _match _correct _approximate
            zstyle ':completion:*:match:*'            original only
            zstyle ':completion:*:approximate:*'      max-errors 1 numeric

            zstyle '*:matches'                        group 'yes'
            zstyle ':completion:*'                    group-name ""
            zstyle ':completion:*:*:-command-:*'      group-order builtins functions aliases commands
            zstyle ':completion:*'                    group-order files directories

            zstyle ':completion:*'                    list-dirs-first true
            zstyle ':completion:*'                    auto-description
            zstyle ':completion:*'                    file-patterns '%p:globbed-files' '*(-/):directories' '*:all-files'

            zstyle ':completion:*:manuals'            separate-sections true
            zstyle ':completion:*:manuals.(^1*)'      insert-sections   true

            zstyle ':completion:*:corrections'        format '%F{green}  %d (errors: %e)  %f'
            zstyle ':completion:*:messages'           format '%B%F{magenta}  %U%d%u  %f%b'
            zstyle ':completion:*:warnings'           format '%B%F{red} %Uno matches found%u %f%b'
            zstyle ':completion:*:default'            list-colors ''${(s.:.)LS_COLORS}
            # Menu-selection bar in ANSI 0-15 so it tracks kitty's live Noctalia palette
            zstyle ':completion:*'                    list-colors 'ma=48;5;4;38;5;0'

            zstyle ':completion:*:parameters'         ignored-patterns '_*'

            zstyle ':completion:*'                    use-cache on
            zstyle ':completion:*'                    cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

            zstyle ':completion:*:functions'          ignored-patterns '([-])*' # ignore builtin functions that start with -

            # fzf-tab pager: ←/→ switch between completion groups WHEN several exist.
            zstyle ':fzf-tab:*'                       switch-group left right
            zstyle ':fzf-tab:*'                       fzf-flags --height=60% --layout=reverse --border --info=inline --color=16

            # Preview files/dirs ONLY for path-taking commands, so subcommand/option
            # completions keep full width instead of an empty preview pane.
            _ftb_preview='if [[ -d $realpath ]]; then eza -1 --icons --color=always --group-directories-first -- $realpath;
                          elif [[ -f $realpath ]]; then bat --color=always --style=numbers --line-range=:200 -- $realpath; fi'
            for _cmd in cd z ls eza bat cat less nvim vim cp mv rm; do
              zstyle ":fzf-tab:complete:$_cmd:*" fzf-preview "$_ftb_preview"
            done
            unset _ftb_preview _cmd
          '';
        };
      };
    };
  };
}
