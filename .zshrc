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
	$EDITOR $(git diff --name-only "HEAD~$depth" | fzf)
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
alias zp="zellij --layout project"

PATH="$HOME/.local/bin:$HOME/.yarn/bin:$HOME/go/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Starship Prompt
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Neovim
zinit ice from"gh-r" as"program" ver"stable" \
	sbin"**/nvim"
zinit light neovim/neovim

# Zellij
zinit ice from"gh-r" as"command" \
	atclone"./zellij setup --generate-completion zsh > _zellij" \
	atpull"%atclone" \
	atload"source ./_zellij &> /dev/null"
zinit load zellij-org/zellij

# exa
zinit ice wait"2" lucid from"gh-r" as"program" \
	sbin"**/exa"
zinit light ogham/exa

# fzf
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# fd
zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

# bat
zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# ripgrep
zinit ice from"gh-r" as"program" \
	sbin"**/rg"
zinit light BurntSushi/ripgrep

# asdf
zinit ice from"gh" as"null" \
	ver"v0.15.0" \
	atclone"cp -R . $HOME/.asdf" \
	atpull"%atclone"
zinit light asdf-vm/asdf

# direnv
zinit ice from"gh-r" as"program" \
	mv"direnv* -> direnv"
zinit light direnv/direnv

# Some plugins for completions and shortcut aliases
zinit wait lucid for \
  OMZL::functions.zsh \
  OMZL::clipboard.zsh \
  OMZL::compfix.zsh \
  OMZL::completion.zsh \
  OMZL::directories.zsh \
  OMZL::git.zsh \
  OMZL::history.zsh \
  OMZL::prompt_info_functions.zsh \
  OMZL::spectrum.zsh \
  OMZL::termsupport.zsh \
  OMZL::theme-and-appearance.zsh \
  atinit"
    VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
    VI_MODE_SET_CURSOR=true" \
    OMZP::vi-mode \
  OMZP::git \
  OMZP::cp \
  OMZP::node \
  OMZP::yarn \
  OMZP::asdf

zinit wait lucid for \
  blockf atpull"zinit creinstall -q ." \
    zsh-users/zsh-completions \
	atinit"zicompinit;zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

# Start with Insert Mode Cursor
echo -ne '\e[5 q'

# direnv is an extension for your shell. It augments existing shells with a new feature that can load and unload environment variables depending on the current directory.
# Peep https://direnv.net/ for more
eval "$(direnv hook zsh)"
