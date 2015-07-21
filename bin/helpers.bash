#!/usr/bin/env bash

alias ll='ls -al'
alias ls='ls -GFh'

# generate password
alias passgen="openssl rand -base64 ${1:-10} | tee >(tr -d '\n' | pbcopy)"
