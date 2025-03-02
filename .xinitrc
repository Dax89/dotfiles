#!/bin/sh

execute_if() {
    cmd=$1
    shift

    if command -v "$cmd" >/dev/null && ! pgrep -f "$cmd" >/dev/null; then
        "$cmd" "$@" &
    fi
}

has_systemd() {
    command -v systemctl >/dev/null
}

setup_services() {
    # Start localization service
    if [ -f /usr/lib/geoclue-2.0/demos/agent ]; then
        /usr/lib/geoclue-2.0/demos/agent &
    elif [ -f /usr/libexec/geoclue-2.0/demos/agent ]; then
        /usr/libexec/geoclue-2.0/demos/agent &
    fi

    [ ! "$(has_systemd)" ] && execute_if pipewire
    execute_if picom --config "$HOME"/.config/picom/picom.conf
    execute_if dunst --config "$HOME"/.config/dunst/dunstrc
    execute_if greenclip daemon >/dev/null
    execute_if redshift
    execute_if protonmail-bridge --noninteractive
}

# Source initialization scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

[ -f ~/.bash_profile ] && . "$HOME"/.bash_profile

# Start OpenRGB
"$HOME"/.me/scripts/openrgb.sh &
setup_services

# Keep monitor active
xset -dpms &
xset s off &

# Faster repeat rate
xset r rate 250 50 &

# exec i3
exec dbus-run-session -- /usr/bin/i3
