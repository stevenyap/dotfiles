parse_git_branch() { git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1)/"; }
export PS1="\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[00m\]\$(parse_git_branch)\$ "

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
alias ll='ls -al'
alias ls='ls -GFh'

export LC_ALL='en_US.UTF-8'  
export LANG='en_US.UTF-8'
export EDITOR='vim'

source ~/.dotfiles/bin/git-completion.bash
source ~/.dotfiles/bin/tmuxinator.bash
