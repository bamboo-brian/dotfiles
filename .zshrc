#!/bin/zsh

# VIM keybindings for editing the prompt
bindkey -v

# The history file store previously run commands
HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000

# Setting KEYTIMEOUT to a low value increases response times for some actions
KEYTIMEOUT=1

# Set some preferences:
# autocd: If you type the name of a directory, cd into that directory
# extendedglob: Adds additional special characters for searching files
# notify: Report the status of background jobs immediately
# promptsubst: Perform substitution in the prompt
setopt autocd extendedglob notify promptsubst

edit_modified() {
	depth=${1:-1}
	$EDITOR $(git diff --name-only "HEAD~$depth" | fzf --preview-window 'up' --preview "git diff --color 'HEAD~$depth' {}")
}

edit_find() {
	if [ "$@" ]; then
		if test -f "$@"; then
			file="$@"
		else
			file=$(fzf -f "$@" | fzf -1)
		fi
	else
		file=$(fzf)
	fi

	if [ "$file" ]; then
		$EDITOR $file
	fi
}

edit_grep() {
	if [ -z "$@" ]; then
		return 1
	fi

	file=$(rg -li "$@" | \
		fzf --preview-window 'up' --bind 'ctrl-d:preview-down' --bind 'ctrl-u:preview-up' --preview "egp '$@' {}")

	if [ "$file" ]; then
		$EDITOR -c "/$@" $file
	fi
}

# Sets NVIM as the default editor and lets you type 'e' to start nvim
export VISUAL=nvim
export EDITOR=nvim
export PAGER=bat
alias e=$EDITOR
alias ef=edit_find
alias eg=edit_grep
alias em=edit_modified
alias ediff='nvim +DiffviewOpen'
alias z=zellij

PATH="$HOME/.local/bin:$HOME/.yarn/bin:$HOME/go/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Homebrew (Linux only)
if [[ "$OSTYPE" == linux* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# Required by OMZ plugins loaded via sheldon (e.g. mise completion cache)
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"

# Load plugins via sheldon
eval "$(sheldon source)"

# Starship prompt
eval "$(starship init zsh)"

# direnv
eval "$(direnv hook zsh)"

# Start with Insert Mode Cursor
echo -ne '\e[5 q'
