#!/bin/bash

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LC_ALL='en_US.UTF-8'  
export LANG='en_US.UTF-8'
export EDITOR='vim'

source ~/.dotfiles/.bash_prompt
source ~/.dotfiles/bin/git-completion.bash
source ~/.dotfiles/bin/tmuxinator.bash
source ~/.dotfiles/bin/helpers.bash
