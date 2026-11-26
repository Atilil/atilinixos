#!/usr/bin/env bash
# PostToolUse(Edit|Write): format .nix files with alejandra.
# flake.nix is skipped because flake-file generates it.

event=$(cat)
file_path=$(echo "$event" | jq -r '.tool_input.file_path // empty')

[ -z "$file_path" ] && exit 0

case "$file_path" in
  *.nix) ;;
  *) exit 0 ;;
esac

case "$file_path" in
  */flake.nix|flake.nix) exit 0 ;;
esac

[ ! -f "$file_path" ] && exit 0

if command -v alejandra >/dev/null 2>&1; then
  alejandra --quiet "$file_path" >/dev/null 2>&1 || true
fi

exit 0
