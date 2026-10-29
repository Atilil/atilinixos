#!/usr/bin/env bash
# Usage: build-uncached.sh HOST [GCROOT_DIR]
# Builds only what no substituter provides; with GCROOT_DIR, keeps the outputs as gcroots there.
set -euo pipefail

host=$1
gcroot_dir=${2:-}
attr=".#nixosConfigurations.$host.config.system.build.toplevel"
plan=$(mktemp)

nix build --dry-run "$attr" 2>&1 | tee "$plan"

mapfile -t drvs < <(awk '/will be built:$/ {b=1; next} /^[^ ]/ {b=0} b && /\.drv$/ {print $1}' "$plan")
todo=()
for drv in "${drvs[@]}"; do
  # Skip assembly derivations (toplevel, system-path...): building them pulls the whole closure
  [ "$(nix-store --query --binding preferLocalBuild "$drv" 2>/dev/null || true)" = 1 ] || todo+=("$drv^*")
done

echo "$host: ${#drvs[@]} derivations not in any cache, ${#todo[@]} to build"
[ "${#todo[@]}" -gt 0 ] || exit 0

if [ -n "$gcroot_dir" ]; then
  # One directory per run: --out-link suffixes the links (-1, -2...) for multiple installables
  mkdir -p "$gcroot_dir/$host-$GITHUB_RUN_ID"
  nix build --print-build-logs --out-link "$gcroot_dir/$host-$GITHUB_RUN_ID/out" "${todo[@]}"
else
  nix build --print-build-logs --no-link "${todo[@]}"
fi
