#!/bin/sh

execute_if() {
    cmd=$1; shift

    if which "$cmd" > /dev/null && ! pgrep -f "$cmd" > /dev/null; then
        "$cmd" "$@" &
    fi
}

# Source initialization scripts
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Start localization service
if [ -f /usr/lib/geoclue-2.0/demos/agent ]; then
    /usr/lib/geoclue-2.0/demos/agent &
elif [ -f /usr/libexec/geoclue-2.0/demos/agent ]; then
    /usr/libexec/geoclue-2.0/demos/agent &
fi

[ -f ~/.bash_profile ] && . "$HOME"/.bash_profile

execute_if picom --config "$HOME"/.config/picom/picom.conf
execute_if dunst --config "$HOME"/.config/dunst/dunstrc
execute_if redshift

xset r rate 250 50 &
exec i3
