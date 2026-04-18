# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with GNU Stow. Run `./install.sh` on a new machine to install Homebrew, all packages, and symlink dotfiles into `$HOME`.

To apply changes after adding new config files:
```sh
stow --target="$HOME" home
```

## Installation

`install.sh` does three things in order:
1. Installs Homebrew if not present (Linux only: also requires `eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"` in `.zshrc`)
2. Runs `brew bundle` to install all packages from `Brewfile`
3. Runs `stow --target="$HOME" home` to symlink home-managed dotfiles, then copies the tracked `.zshrc` wrapper into place as a local `~/.zshrc`

## Structure

Home-managed files live under `home/`, which mirrors `$HOME` for Stow:
- `home/.config/` mirrors `~/.config/`
- `home/.zshrc.shared` mirrors `~/.zshrc.shared`

Repo-only files such as `CLAUDE.md`, `install.sh`, `Brewfile`, and `.zshrc` stay at the repository root. The real `~/.zshrc` is copied from the tracked wrapper by `install.sh` so app-managed edits do not touch tracked files.

### Shell (`.zshrc`, `home/.zshrc.shared`)
- `.zshrc` is the tracked wrapper template copied to `~/.zshrc`
- Zsh with vi keybindings (`bindkey -v`)
- Plugins managed by **sheldon** (`eval "$(sheldon source)"`)
- Prompt via **starship** (`eval "$(starship init zsh)"`)
- Runtime versions via **mise** (handled by the OMZ mise plugin loaded through sheldon)
- Directory env vars via **direnv**
- Custom editor functions: `edit_find` (`ef`), `edit_grep` (`eg`), `edit_modified` (`em`)
- Optional machine-local overrides in `~/.zshrc.local`

### Sheldon (`home/.config/sheldon/plugins.toml`)
Loads zsh plugins in this order — order matters:
1. `zsh-completions` + `compinit` — must run first so `compdef` is available
2. OMZ libraries (`lib/*.zsh`)
3. OMZ plugins: vi-mode, git, cp, node, yarn, mise
4. `fast-syntax-highlighting`

### Neovim (`home/.config/nvim/`)
Uses **lazy.nvim** (auto-bootstrapped in `init.lua`). Plugin specs are split by category under `lua/plugins/`:
- `init.lua` — loads all category modules and core plugins (gitsigns, diffview, undotree, editorconfig)
- `appearance.lua`, `completion.lua`, `navigation.lua`, `motion.lua`, `treesitter.lua`, `lsp.lua`, `testing.lua`, `debug.lua`

Keymaps live in `lua/keymaps.lua`, autocommands in `lua/autocmds.lua`, shared utilities in `lua/util.lua`.

### Zellij (`home/.config/zellij/`)
- `config.kdl` — keybindings with defaults cleared; uses the `dracula` theme
- `layouts/` — custom pane layouts and status plugins
- `themes/` — color themes (dracula, match-term, nightfox, rose-pine)

### Starship (`home/.config/starship.toml`)
Custom prompt showing: directory, git branch/state/metrics, language versions (Go, Node, PHP), command duration, and vi mode indicator.

### Ghostty (`home/.config/ghostty/config`)
Terminal emulator config: Dracula theme, JetBrainsMono Nerd Font, custom fullscreen toggle binding.
