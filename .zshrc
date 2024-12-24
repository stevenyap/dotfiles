#!/bin/bash

export CLICOLOR=1
export LS_COLORS=GxFxCxDxBxegedabagaced
export LC_ALL='en_US.UTF-8'  
export LANG='en_US.UTF-8'
export EDITOR='nvim'
alias ll='ls -al'
alias ls='ls -GFh'

# zsh plugins using antigen installed using homebrew
source /opt/homebrew/share/antigen/antigen.zsh

# Vim-like key binding
antigen bundle jeffreytse/zsh-vi-mode

# prompt theme
antigen theme denysdovhan/spaceship-prompt
SPACESHIP_TIME_SHOW=true

# Various auto-completions in zsh
# Used for tmuxinator, nvm
# https://github.com/zsh-users/zsh-completions/tree/master/src
antigen bundle zsh-users/zsh-completions

antigen bundle zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080,underline"

# zsh-syntax-highlighting must be the last!
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Extra bindings
bindkey '^L' autosuggest-accept # move right to accept suggestion
bindkey '^D' backward-delete-word

# Manual link to stree
alias stree="/Applications/SourceTree.app/Contents/Resources/stree"

# Set tmuxinator project config folder
export TMUXINATOR_CONFIG="$HOME/Workspace/dotfiles/tmuxinator"
alias mux="tmuxinator"

# Autojump plugin: https://github.com/wting/autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Alias to see all my github tasks
alias ghtasks="(set -x && gh issue list --assignee @me && gh pr status)"

# History of commands
# Save all commands to a history file
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY


# C_INCLUDE_PATH is needed for arm64 Apple machine when building Haskell FFI
# Added when trying to use https://github.com/portnov/libssh2-hs
# https://gitlab.haskell.org/ghc/ghc/-/issues/20592#note_391266
export C_INCLUDE_PATH="$(xcrun --show-sdk-path)/usr/include/ffi"

# Our own compiled binaries
# TODO Remove elm-format when arm64 binary is available
export PATH=$PATH:$HOME/Workspace/dotfiles/bin

### Coding Specific Configs ###

# Use Homebrew git over mac git
export PATH="/opt/homebrew/bin/git:${PATH}"

# NodeJS
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
# Use local npm binaries over global npm binaries
export PATH=./node_modules/.bin:${PATH}

# React Native android emulator
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Ruby
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.0.0/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib:LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include:$CPPFLAGS"
# For fastlane
export PATH="$HOME/.fastlane/bin:$PATH"

# OpenJDK: brew install --cask zulu@17
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# MySQL
export PATH=/usr/local/mysql/bin:$PATH
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ghcup-env
[ -f "/Users/stevenyap/.ghcup/env" ] && source "/Users/stevenyap/.ghcup/env" 

# brew install llvm
# For compiling of elm-format using ghcup
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
