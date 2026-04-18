#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
wrapper_target="$HOME/.zshrc"
wrapper_source="$repo_root/.zshrc"

if command -v brew &>/dev/null; then
  echo "Homebrew is already installed."
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle

stow --target="$HOME" --ignore='^\.zshrc$' .

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
