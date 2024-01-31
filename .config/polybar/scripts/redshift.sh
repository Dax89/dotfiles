#!/bin/sh

# DAY=6500
# NIGHT=3500

find_pid() {
    pgrep -x redshift
}

if [ "$1" = 'toggle' ]; then
    pid=$(find_pid)

    if [ -z "$pid" ]; then
        redshift -v &
    else
        kill -9 "$pid"
        redshift -x
    fi

    exit 0
fi

read_period() {
    period=$(redshift -p 2>&1 /dev/null | awk '/Period:/{print $2}')

    case "$period" in
        Daytime) echo '%{F#7e9cd8}%{F-}' ;;
        Transition) echo '%{F#e6c384}󰖚%{F-}' ;;
        Night) echo '%{F#e82424}󰖔%{F-}' ;;
        *) echo '%{F#dcd7ba}%{F-}' ;;
    esac
}

if [ -z "$(find_pid)" ]; then
  echo '%{F#98bb6c}%{T2}󰔎%{T-}%{F-}'
else
  echo "%{T2}$(read_period)%{T-}"
fi
