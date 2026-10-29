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

# Skip assembly drvs (they pull their whole closure); with __structuredAttrs the flags are in env.__json.
keep='(.derivations // .) | to_entries[]
  | (.value.env.__json // null | if . then fromjson else null end) as $a
  | select(
      (if $a then $a.allowSubstitutes == false or ($a | has("exportReferencesGraph"))
       else .value.env.allowSubstitutes == "" or (.value.env | has("exportReferencesGraph")) end
       or (.key | test("-nixos-system-"))) | not)
  | .key + "^*"'
todo=()
if [ "${#drvs[@]}" -gt 0 ]; then
  info=$(nix derivation show "${drvs[@]}")
  mapfile -t todo < <(jq -r "$keep" <<<"$info")
fi

echo "$host: ${#drvs[@]} derivations not in any cache, ${#todo[@]} to build"
[ "${#todo[@]}" -gt 0 ] || exit 0
if [ "${#todo[@]}" -gt "${MAX_BUILDS:-30}" ]; then
  echo "refusing to build ${#todo[@]} derivations (MAX_BUILDS=${MAX_BUILDS:-30}): the cache is probably behind the lock" >&2
  exit 1
fi

if [ -n "$gcroot_dir" ]; then
  # One directory per run: --out-link suffixes the links (-1, -2...) for multiple installables
  mkdir -p "$gcroot_dir/$host-$GITHUB_RUN_ID"
  nix build --print-build-logs --out-link "$gcroot_dir/$host-$GITHUB_RUN_ID/out" "${todo[@]}"
else
  nix build --print-build-logs --no-link "${todo[@]}"
fi
