#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ "$(uname -s)" != Darwin ]] || ! command -v aerospace &>/dev/null; then
  echo "Skipping AeroSpace configuration: requires macOS and aerospace."
  exit 0
fi

source="$repo_root/aerospace/.aerospace.toml"
target="$HOME/.aerospace.toml"
alternate="${XDG_CONFIG_HOME:-$HOME/.config}/aerospace/aerospace.toml"

# AeroSpace rejects configs present in both its supported locations.
for config in "$target" "$alternate"; do
  if [[ -e "$config" && ! -f "$config" ]] || [[ -L "$config" && -d "$config" ]]; then
    echo "Refusing to replace non-file AeroSpace configuration: $config" >&2
    exit 1
  fi
done

backup=""
if [[ -e "$target" || -L "$target" ]]; then
  if ! [[ -L "$target" && "$target" -ef "$source" ]]; then
    backup="$(mktemp -d "$HOME/.aerospace.backup.XXXXXX")"
    mv "$target" "$backup/home-config.toml"
  fi
fi
if [[ -e "$alternate" || -L "$alternate" ]]; then
  if [[ -z "$backup" ]]; then
    backup="$(mktemp -d "$HOME/.aerospace.backup.XXXXXX")"
  fi
  mv "$alternate" "$backup/xdg-config.toml"
fi
if [[ -n "$backup" ]]; then
  echo "Backed up existing AeroSpace configuration to $backup"
fi

stow --dir="$repo_root" --target="$HOME" --no-folding aerospace
echo "Installed AeroSpace configuration. Start AeroSpace, then run: aerospace reload-config"
