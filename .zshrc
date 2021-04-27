#!/bin/bash

export CLICOLOR=1
export LS_COLORS=GxFxCxDxBxegedabagaced
export LC_ALL='en_US.UTF-8'  
export LANG='en_US.UTF-8'
export EDITOR='nvim'
alias ll='ls -al'
alias ls='ls -GFh'

# zsh plugins
source $HOME/Workspace/dotfiles/antigen.zsh

antigen bundle zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#D7D7D7,underline"

antigen theme denysdovhan/spaceship-prompt

# Various auto-completions in zsh
# Used for tmuxinator, nvm
# https://github.com/zsh-users/zsh-completions/tree/master/src
antigen bundle zsh-users/zsh-completions

# zsh-syntax-highlighting must be the last!
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Vim-like key binding
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Movement-1
bindkey '' vi-backward-char # move left
bindkey '' autosuggest-accept # move right to accept suggestion
bindkey '' vi-backward-word # move left by a word
bindkey '' vi-forward-word # move right by a word
bindkey '' vi-beginning-of-line
bindkey '' vi-end-of-line
bindkey '' backward-delete-word
bindkey '' up-history
# CTRL-J is a return line in terminal
# We map Ctrl-J in iterm2 to Ctrl-T and capture it here
# Add hex code 0x14 to Ctrl-J
bindkey '' down-history 

# Manual link to stree
alias stree="/Applications/SourceTree.app/Contents/Resources/stree"

# Alias to ag
alias ag="ag --path-to-ignore $HOME/Workspace/dotfiles/.agignore"

# Set tmuxinator project config folder
export TMUXINATOR_CONFIG="$HOME/Workspace/dotfiles/tmuxinator"
alias mux="tmuxinator"

# Autojump plugin: https://github.com/wting/autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# History of commands
# Save all commands to a history file
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY

### Coding Specific Configs ###

# NodeJS
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
# Use local npm binaries over global npm binaries
export PATH=./node_modules/.bin:${PATH}

# React Native android emulator
export ANDROID_HOME=~/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

# Ruby
# For fastlane
export PATH="$HOME/.fastlane/bin:$PATH"
# Add gem bin path
export PATH="/Users/stevenyap/.gem/ruby/2.6.0/bin:$PATH"

# MySQL
export PATH=/usr/local/mysql/bin:$PATH
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
