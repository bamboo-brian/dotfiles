# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with GNU Stow. Run `./install.sh` on a new machine to install Homebrew, all packages, and symlink dotfiles into `$HOME`.

To apply changes after adding new config files:
```sh
stow --target="$HOME" home
```

## Installation

`install.sh` installs packages from `Pacmanfile` on pacman systems, otherwise
installs Homebrew if needed and runs `brew bundle`. It then stows `home`, copies
the tracked `.zshrc` wrapper into place, and invokes the gated Hyprland and
AeroSpace installers.

## Structure

Home-managed files live under `home/`, which mirrors `$HOME` for Stow:
- `home/.config/` mirrors `~/.config/`
- `home/.zshrc.shared` mirrors `~/.zshrc.shared`

Repo-only files such as `CLAUDE.md`, `install.sh`, `Brewfile`, and `.zshrc` stay at the repository root. The real `~/.zshrc` is copied from the tracked wrapper by `install.sh` so app-managed edits do not touch tracked files.

### Hyprland (`hyprland/.config/hypr/`)
- A separate Stow package, applied only on Linux with `Hyprland` on `PATH`
- Apply through `bash scripts/install-hyprland.sh`; it honors `XDG_CONFIG_HOME`
- Shared Lua modules provide bindings and general preferences
- Optional untracked `local-options.lua` configures commands and monitor names;
  `local-settings.lua` applies hardware/session settings and final overrides
- Never put machine-local hooks in the Stow package or move this package into `home`
- See `README.md` for migration, backups, and verification
- Run `python3 scripts/test-hyprland.py` for isolated installer/config checks

### AeroSpace (`aerospace/.aerospace.toml`)
- Separate macOS-only Stow package, applied when `aerospace` is on `PATH`
- Apply through `bash scripts/install-aerospace.sh`
- Command+H/J/K/L navigates windows; Command+Option navigates workspaces
- Installer backs up conflicting home and XDG configs to avoid ambiguous loading
- Run `python3 scripts/test-aerospace.py` for installer and TOML checks

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
