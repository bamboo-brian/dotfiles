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

# Sets NVIM as the default editor and lets you type 'e' to start nvim
export VISUAL=nvim
export EDITOR=nvim
export PAGER=bat
alias e=$EDITOR
alias ef='e $(fzf)'
alias z=zellij
alias phpstorm=nvim
alias branches="git for-each-ref --sort=-committerdate refs/heads --format='%(refname:short)' | gum filter"


NNN_PLUG="f:finder;p:preview-tui"
NNN_FIFO=/tmp/nnn.fifo

PATH="$HOME/.local/bin:$HOME/.scripts/tools:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

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
#
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

# Zellij
zinit ice from"gh-r" as"command" \
	atclone"./zellij setup --generate-completion zsh > _zellij" \
	atpull"%atclone" \
	atload"source ./_zellij &> /dev/null"
zinit load zellij-org/zellij

# fzf
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf-bin

# fd
zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

# bat
zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# asdf
zinit ice from"gh" as"null" \
	atclone"cp -R . $HOME/.asdf" \
	atpull"%atclone" 
zinit light asdf-vm/asdf

# Some plugins for completions and shortcut aliases
zinit wait lucid for \
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
