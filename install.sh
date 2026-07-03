#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
wrapper_target="$HOME/.zshrc"
wrapper_source="$repo_root/.zshrc"

parse_pacmanfile_section() {
  local section="$1"
  awk "/^\[$section\]/{found=1; next} /^\[/{found=0} found && /^[^#[:space:]]/{print}" "$repo_root/Pacmanfile"
}

if command -v pacman &>/dev/null; then
  mapfile -t pacman_pkgs < <(parse_pacmanfile_section pacman)
  sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"

  mapfile -t aur_pkgs < <(parse_pacmanfile_section aur)
  if command -v yay &>/dev/null; then
    yay -S --needed --noconfirm "${aur_pkgs[@]}"
  else
    echo "Warning: yay not found; skipping AUR packages: ${aur_pkgs[*]}" >&2
  fi
else
  if command -v brew &>/dev/null; then
    echo "Homebrew is already installed."
  else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew bundle
fi

while IFS= read -r conflict; do
  tgt="$HOME/$conflict"
  echo "Backing up conflicting file: $tgt -> $tgt.bak"
  mv "$tgt" "$tgt.bak"
done < <(stow -n --target="$HOME" home 2>&1 | sed -En 's/.* existing target (.*) since neither.*/\1/p')

stow --target="$HOME" home

if [ -L "$wrapper_target" ]; then
  rm "$wrapper_target"
fi

if [ -e "$wrapper_target" ] && [ ! -f "$wrapper_target" ]; then
  echo "Refusing to overwrite non-file $wrapper_target" >&2
  exit 1
fi

if [ -f "$wrapper_target" ]; then
  expected_link="source \"$HOME/.zshrc.shared\""
  if ! grep -Fq "$expected_link" "$wrapper_target"; then
    backup_target="$wrapper_target.pre-dotfiles-wrapper-backup"
    cp "$wrapper_target" "$backup_target"
    echo "Backed up existing $wrapper_target to $backup_target"
    cp "$wrapper_source" "$wrapper_target"
  fi
else
  cp "$wrapper_source" "$wrapper_target"
fi

chmod 0644 "$wrapper_target"
