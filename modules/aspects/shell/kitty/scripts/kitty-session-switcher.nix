_: {
  den.aspects.kitty.homeManager = {pkgs, ...}: let
    # fzf switcher over the open kitty sessions; complements kitty-session-picker.
    # Adapted from https://github.com/linkarzu/dotfiles-latest/blob/main/kitty/scripts/kitty-list-sessions.sh
    kittySessionSwitcher = pkgs.writeShellApplication {
      name = "kitty-session-switcher";
      runtimeInputs = [pkgs.fzf pkgs.jq];
      text = ''
        set -euo pipefail

        build_menu_lines() {
          kitty @ ls 2>/dev/null | jq -r '
            [
              .[] as $os
              | $os.tabs[] as $tab
              | $tab.windows[]?
              | select(.session_name != null and .session_name != "")
                | {
                    session_name: .session_name,
                    pwd: (.env.PWD // .cwd),
                    os_focused: ($os.is_focused // false),
                    tab_focused: ($tab.is_focused // false),
                    last_focused_at: (.last_focused_at // 0)
                  }
            ]
            | sort_by(.session_name)
            | group_by(.session_name)
            | map({
                session_last_focused_at: (map(.last_focused_at) | max),
                pick: (
                  if (map(.os_focused and .tab_focused) | any) then
                    (map(select(.os_focused and .tab_focused)) | .[0])
                  else
                    .[0]
                  end
                )
              })
            | map(.pick + {session_last_focused_at: .session_last_focused_at})
            | sort_by(-.session_last_focused_at, .session_name)
            | .[]
            | [(.session_name|tostring), (.os_focused|tostring), (.tab_focused|tostring), (.pwd|tostring)]
            | @tsv
          ' | awk -F'\t' -v home="$HOME" '{
            session_name=$1; os_focused=$2; tab_focused=$3; path=$4
            if (home != "" && index(path, home) == 1) { path = "~" substr(path, length(home) + 1) }
            marker = (os_focused == "true" && tab_focused == "true") ? "*" : " "
            printf "%d\t%s\t%s %s  %s\n", NR, session_name, marker, session_name, path
          }'
        }

        mode="insert"

        while true; do
          menu_lines="$(build_menu_lines || true)"
          if [[ -z "''${menu_lines:-}" ]]; then
            echo "No open sessions found."
            exit 1
          fi

          if [[ "$mode" == "normal" ]]; then
            fzf_out="$(
              printf "%s\n" "$menu_lines" |
                fzf --ansi --height=100% --reverse \
                  --header="Normal: j/k move, d close, enter open, i insert, esc quit" \
                  --prompt="Kitty sessions > " \
                  --no-multi --disabled \
                  --with-nth=3.. \
                  --expect=enter,d,i,esc \
                  --bind 'j:down,k:up' \
                  --bind 'enter:accept,d:accept,i:accept' \
                  --bind 'esc:abort'
            )" || true
          else
            fzf_out="$(
              printf "%s\n" "$menu_lines" |
                fzf --ansi --height=100% --reverse \
                  --header="Insert: type to filter, enter open, esc normal" \
                  --prompt="Kitty sessions > " \
                  --no-multi \
                  --with-nth=3.. \
                  --expect=enter,esc \
                  --bind 'enter:accept' \
                  --bind 'esc:abort'
            )" || true
          fi

          key="$(printf "%s\n" "$fzf_out" | head -n1)"
          sel="$(printf "%s\n" "$fzf_out" | sed -n '2p' || true)"
          selected_title="$(printf "%s" "$sel" | awk -F'\t' '{print $2}')"

          if [[ "$mode" == "insert" && "$key" == "esc" ]]; then mode="normal"; continue; fi
          if [[ "$mode" == "normal" && "$key" == "esc" ]]; then exit 0; fi
          if [[ "$mode" == "normal" && "$key" == "i" ]]; then mode="insert"; continue; fi
          if [[ -z "''${selected_title:-}" ]]; then
            if [[ "$mode" == "normal" ]]; then exit 0; fi
            mode="normal"; continue
          fi
          if [[ "$mode" == "normal" && "$key" == "d" ]]; then
            kitty @ action close_session "$selected_title" >/dev/null 2>&1 || true
            continue
          fi
          if [[ "$key" == "enter" ]]; then
            kitty @ action goto_session "$selected_title"
            exit 0
          fi
          if [[ "$mode" == "insert" ]]; then mode="normal"; continue; fi
          exit 0
        done
      '';
    };
  in {
    programs.kitty = {
      keybindings = {
        "f7" = "launch --type=overlay ${kittySessionSwitcher}/bin/kitty-session-switcher";
      };
    };
  };
}
