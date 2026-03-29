# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with GNU Stow. Run `./install.sh` on a new machine to install Homebrew, all packages, and symlink dotfiles into `$HOME`.

To apply changes after adding new config files:
```sh
stow --target="$HOME" .
```

## Installation

`install.sh` does three things in order:
1. Installs Homebrew if not present (Linux only: also requires `eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"` in `.zshrc`)
2. Runs `brew bundle` to install all packages from `Brewfile`
3. Runs `stow --target="$HOME" .` to symlink dotfiles

## Structure

All config files live under `.config/` (mirrors `~/.config/`) and `.zshrc` (mirrors `~/.zshrc`). Stow creates symlinks from `$HOME` to this repo.

### Shell (`.zshrc`)
- Zsh with vi keybindings (`bindkey -v`)
- Plugins managed by **sheldon** (`eval "$(sheldon source)"`)
- Prompt via **starship** (`eval "$(starship init zsh)"`)
- Runtime versions via **mise** (handled by the OMZ mise plugin loaded through sheldon)
- Directory env vars via **direnv**
- Custom editor functions: `edit_find` (`ef`), `edit_grep` (`eg`), `edit_modified` (`em`)

### Sheldon (`.config/sheldon/plugins.toml`)
Loads zsh plugins in this order — order matters:
1. `zsh-completions` + `compinit` — must run first so `compdef` is available
2. OMZ libraries (`lib/*.zsh`)
3. OMZ plugins: vi-mode, git, cp, node, yarn, mise
4. `fast-syntax-highlighting`

### Neovim (`.config/nvim/`)
Uses **lazy.nvim** (auto-bootstrapped in `init.lua`). Plugin specs are split by category under `lua/plugins/`:
- `init.lua` — loads all category modules and core plugins (gitsigns, diffview, undotree, editorconfig)
- `appearance.lua`, `completion.lua`, `navigation.lua`, `motion.lua`, `treesitter.lua`, `lsp.lua`, `testing.lua`, `debug.lua`

Keymaps live in `lua/keymaps.lua`, autocommands in `lua/autocmds.lua`, shared utilities in `lua/util.lua`.

### Zellij (`.config/zellij/`)
- `config.kdl` — keybindings with defaults cleared; uses `match-term` theme
- `layouts/` — custom pane layouts
- `themes/` — color themes (match-term, nightfox, rose-pine)

### Starship (`.config/starship.toml`)
Custom prompt showing: directory, git branch/state/metrics, language versions (Go, Node, PHP), command duration, and vi mode indicator.

### Ghostty (`.config/ghostty/config`)
Terminal emulator config: Gruvbox Material theme, RobotoMono Nerd Font, fullscreen by default.
