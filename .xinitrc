#!/bin/sh

# Source initialization scripts
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

[ -f ~/.bash_profile ] && . "$HOME"/.bash_profile

xset r rate 250 50 &
exec i3
