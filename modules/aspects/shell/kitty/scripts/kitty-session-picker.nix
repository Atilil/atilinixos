_: {
  den.aspects.kitty.homeManager = {pkgs, ...}: let
    # fzf picker to open/create sessions from zoxide dirs, SSH hosts (~/.ssh/config) and saved .kitty-session files;
    # replaces the native goto_session-on-directory picker.
    # Adapted from https://github.com/linkarzu/dotfiles-latest/blob/main/kitty/scripts/kitty-zoxide-session.sh
    kittySessionPicker = pkgs.writeShellApplication {
      name = "kitty-session-picker";
      runtimeInputs = [pkgs.fzf pkgs.jq pkgs.zoxide];
      text = ''
        set -euo pipefail

        session_dir="/tmp/kitty-zoxide-sessions"

        hash_path() {
          printf "%s" "$1" | sha256sum | awk '{print $1}'
        }

        session_exists() {
          local name="$1"
          kitty @ ls 2>/dev/null | jq -e --arg name "$name" '
            any(.[]?.tabs[]?.windows[]?; .session_name == $name)
          ' >/dev/null
        }

        bump_zoxide_score() {
          zoxide add -- "$1" >/dev/null 2>&1 || true
        }

        find_session_by_path() {
          local target="$1" name pwd real
          while IFS=$'\t' read -r name pwd; do
            [[ -z "$name" || -z "$pwd" ]] && continue
            [[ ! -d "$pwd" ]] && continue
            real="$(realpath "$pwd")"
            if [[ "$real" == "$target" ]]; then
              printf "%s" "$name"
              return 0
            fi
          done < <(
            kitty @ ls 2>/dev/null | jq -r '
              .[]?.tabs[]?.windows[]?
              | select(.session_name != null and .session_name != "")
              | [(.session_name|tostring), (.env.PWD // .cwd // "")]
              | @tsv
            '
          )
          return 1
        }

        collect_ssh_config_files() {
          local root_config="$HOME/.ssh/config"
          [[ -f "$root_config" ]] || return 0
          local queue=("$root_config") processed="|" files=()
          while ((''${#queue[@]})); do
            local file="''${queue[0]}"
            queue=("''${queue[@]:1}")
            [[ "$processed" == *"|''${file}|"* ]] && continue
            processed+="''${file}|"
            [[ -f "$file" ]] || continue
            files+=("$file")
            while IFS= read -r line || [[ -n "$line" ]]; do
              line="''${line%%#*}"
              if [[ "$line" =~ ^[[:space:]]*Include[[:space:]]+(.+) ]]; then
                for pattern in ''${BASH_REMATCH[1]}; do
                  pattern="''${pattern/#\~/$HOME}"
                  for match in $pattern; do
                    [[ -f "$match" ]] && queue+=("$match")
                  done
                done
              fi
            done <"$file"
          done
          printf "%s\n" "''${files[@]}"
        }

        print_ssh_menu_lines() {
          local config_files=()
          while IFS= read -r f; do config_files+=("$f"); done < <(collect_ssh_config_files)
          ((''${#config_files[@]})) || return 0
          # Hosts are buffered per block and dropped when the block sets
          # `User git`: those are git forges (gitlab, forgejo), not shells.
          awk '
            function flush(  i) {
              if (!is_git) for (i = 1; i <= n; i++) print hosts[i]
              n = 0; is_git = 0
            }
            FNR == 1 { flush() }
            { sub(/[ \t]*#.*/, "")
              key = tolower($1)
              if (key == "host" || key == "match") {
                flush()
                if (key == "match") next
                for (i = 2; i <= NF; i++) {
                  h = $i
                  if (h ~ /^[!]/) continue
                  if (h ~ /[\\*?]/) continue
                  hosts[++n] = h
                }
              } else if (key == "user" && $2 == "git") {
                is_git = 1
              }
            }
            END { flush() }
          ' "''${config_files[@]}" | sort -u | while IFS= read -r host; do
            [[ -z "$host" ]] && continue
            printf "ssh:%s\tssh-%s\n" "$host" "$host"
          done
        }

        print_saved_session_lines() {
          shopt -s nullglob
          for f in "$HOME/.config/kitty/sessions"/*.kitty-session; do
            name="$(basename "$f" .kitty-session)"
            printf "sess:%s\t%s\n" "$f" "$name"
          done
          shopt -u nullglob
        }

        print_menu_lines() {
          print_saved_session_lines
          print_ssh_menu_lines
          zoxide query -l 2>/dev/null | while IFS= read -r path; do
            base="$(basename "$path")"
            printf "%s\t%s  %s\n" "$path" "$base" "$path"
          done
        }

        focus_or_launch_dir() {
          local selected_path="$1" selected_real base safe_base hash short_name session_name existing_session session_file
          if [[ ! -d "$selected_path" ]]; then
            echo "Directory not found: $selected_path"
            exit 1
          fi
          selected_real="$(realpath "$selected_path")"
          existing_session="$(find_session_by_path "$selected_real" || true)"
          if [[ -n "$existing_session" ]]; then
            bump_zoxide_score "$selected_real"
            kitty @ action goto_session "$existing_session"
            return 0
          fi
          base="$(basename "$selected_path")"
          safe_base="$(printf "%s" "$base" | tr -cs 'A-Za-z0-9._-' '_')"
          hash="$(hash_path "$selected_real")"
          hash="''${hash:0:4}"
          short_name="z-''${safe_base}"
          session_name="$short_name"
          if session_exists "$short_name"; then
            session_name="''${short_name}-''${hash}"
          fi
          mkdir -p "$session_dir"
          session_file="''${session_dir}/''${session_name}.kitty-session"
          cat >"$session_file" <<EOF
        layout tall
        cd ''${selected_real}
        launch --title "''${base}"
        focus
        focus_os_window
        EOF
          kitty @ action goto_session "$session_file"
          bump_zoxide_score "$selected_real"
        }

        focus_or_launch_ssh() {
          local host="$1" safe_host session_file
          safe_host="$(printf "%s" "$host" | tr -cs 'A-Za-z0-9._-' '_')"
          mkdir -p "$session_dir"
          session_file="''${session_dir}/ssh-''${safe_host}.kitty-session"
          cat >"$session_file" <<EOF
        layout tall
        launch --title "ssh-''${host}" kitten ssh ''${host}
        focus
        focus_os_window
        EOF
          kitty @ action goto_session "$session_file"
        }

        menu_lines="$(print_menu_lines)"
        if [[ -z "''${menu_lines:-}" ]]; then
          echo "Nothing to show (no zoxide entries, saved sessions, or SSH hosts)."
          exit 1
        fi

        set +e
        fzf_out="$(
          printf "%s\n" "$menu_lines" |
            fzf --exact --ansi --height=100% --reverse \
              --header="Type to filter, enter open, esc quit" \
              --prompt="Kitty sessions (zoxide/saved/ssh) > " \
              --no-multi \
              --with-nth=2.. \
              --expect=enter,esc \
              --bind 'enter:accept' \
              --bind 'esc:abort'
        )"
        fzf_rc=$?
        set -e

        if [[ $fzf_rc -ne 0 && -z "''${fzf_out:-}" ]]; then
          exit 0
        fi
        key="$(printf "%s\n" "$fzf_out" | head -n1)"
        if [[ "$key" == "esc" ]]; then
          exit 0
        fi
        sel="$(printf "%s\n" "$fzf_out" | sed -n '2p' || true)"
        selected=""
        if [[ -n "''${sel:-}" ]]; then
          selected="$(printf "%s" "$sel" | awk -F'\t' '{print $1}')"
        fi
        if [[ -z "''${selected:-}" ]]; then
          exit 0
        fi

        case "$selected" in
          ssh:*) focus_or_launch_ssh "''${selected#ssh:}" ;;
          sess:*) kitty @ action goto_session "''${selected#sess:}" ;;
          *) focus_or_launch_dir "$selected" ;;
        esac
      '';
    };
  in {
    programs.kitty.keybindings."f8" = "launch --type=overlay ${kittySessionPicker}/bin/kitty-session-picker";
  };
}
