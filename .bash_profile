#!/bin/bash

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LC_ALL='en_US.UTF-8'  
export LANG='en_US.UTF-8'
export EDITOR='vim'

# For react native android emulator
export ANDROID_HOME=~/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

# For fastlane
export PATH="$HOME/.fastlane/bin:$PATH"

# Use local npm binaries over global npm binaries
export PATH=./node_modules/.bin:${PATH}

source ~/.dotfiles/.bash_prompt
source ~/.dotfiles/bin/git-completion.bash
source ~/.dotfiles/bin/tmuxinator.bash
source ~/.dotfiles/bin/helpers.bash
