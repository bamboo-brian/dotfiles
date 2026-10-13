#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ "$(uname -s)" != Linux ]] || ! command -v Hyprland &>/dev/null; then
  echo "Skipping Hyprland configuration: requires Linux and Hyprland."
  exit 0
fi

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
hypr_dir="$config_home/hypr"
package_root="$repo_root/hyprland/.config"

# Do not write through a directory symlink into another configuration/repository.
if [[ -L "$hypr_dir" ]] || [[ -e "$hypr_dir" && ! -d "$hypr_dir" ]]; then
  echo "Refusing to install through non-directory or symlink: $hypr_dir" >&2
  exit 1
fi

conflicts=()
if [[ -L "$hypr_dir/shared" ]] || [[ -e "$hypr_dir/shared" && ! -d "$hypr_dir/shared" ]]; then
  conflicts+=(shared)
fi
while IFS= read -r -d '' source; do
  relative="${source#"$package_root/hypr/"}"
  [[ "$relative" == shared/* && "${conflicts[0]:-}" == shared ]] && continue
  target="$hypr_dir/$relative"
  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -L "$target" && "$(readlink -f "$target")" == "$source" ]]; then
      continue
    fi
    conflicts+=("$relative")
  fi
done < <(find "$package_root/hypr" -type f -name '*.lua' \
  ! -name local-options.lua ! -name local-settings.lua -print0)

mkdir -p "$hypr_dir"
if (( ${#conflicts[@]} )); then
  backup="$(mktemp -d "$config_home/hypr.backup.XXXXXX")"
  mkdir "$backup/original" "$backup/replaced"
  cp -a "$hypr_dir/." "$backup/original/"
  for relative in "${conflicts[@]}"; do
    mkdir -p "$(dirname "$backup/replaced/$relative")"
    mv "$hypr_dir/$relative" "$backup/replaced/$relative"
  done
  echo "Backed up Hyprland configuration to $backup/original"
fi

stow --dir="$package_root" --target="$hypr_dir" --no-folding hypr
echo "Installed shared Hyprland configuration; local hooks were preserved."
