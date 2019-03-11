#!/bin/bash

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LC_ALL='en_US.UTF-8'  
export LANG='en_US.UTF-8'
export EDITOR='nvim'

# For react native android emulator
export ANDROID_HOME=~/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

# For fastlane
export PATH="$HOME/.fastlane/bin:$PATH"

# Use local npm binaries over global npm binaries
export PATH=./node_modules/.bin:${PATH}

# Put Yarn in PATH
export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"

# Source other bash config/scripts
source ~/.dotfiles/.bash_prompt
source ~/.dotfiles/bin/git-completion.bash
source ~/.dotfiles/bin/tmuxinator.bash
source ~/.dotfiles/bin/helpers.bash

# Manual link to stree
alias stree='/Applications/SourceTree.app/Contents/Resources/stree'

# Alias to ag
alias ag='ag --path-to-ignore ~/.dotfiles/.agignore'

# Set tmuxinator project config folder
export TMUXINATOR_CONFIG="$HOME/.dotfiles/.tmuxinator"
