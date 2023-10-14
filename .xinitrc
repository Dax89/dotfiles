#! /bin/bash

function execute_if() {
    cmd=$1
    args=$2

    if ! command -v "$cmd" &> /dev/null
    then
        "$cmd $args"
    fi
}

# Source initialization scripts
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

[[ -f ~/.bash_profile ]] && . ~/.bash_profile

execute_if 'numlockx' &
xset r rate 250 50 &
exec i3
