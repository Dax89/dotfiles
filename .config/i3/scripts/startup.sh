#!/bin/sh

execute_if() {
    if which "$1" >/dev/null && ! pgrep -f "$1" >/dev/null; then
        "$1" "$2" &
    fi
}

dunstify -a 'Startup' 'Starting applications'

execute_if 'Discord'
execute_if 'Telegram'
execute_if 'thunderbird'
execute_if 'steam' '-silent'
