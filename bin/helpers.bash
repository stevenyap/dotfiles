#!/usr/bin/env bash

# Custom ll and ls
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
alias ll='ls -al'
alias ls='ls -GFh'

# generate password
alias generatepassword="openssl rand -base64 ${1:-10} | tr -d '\n' | tee >(pbcopy) && echo ' is copied to your clipboard'"
