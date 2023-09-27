#! /bin/bash

[[ -f ~/.bash_profile ]] && . ~/.bash_profile

function execute_if() {
    cmd=$1
    args=$2

    if ! command -v "$cmd" &> /dev/null
    then
        "$cmd $args"
    fi
}

execute_if 'numlockx' &
xset r rate 250 50 &
exec i3
