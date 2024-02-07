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
        Daytime) echo '%{F#90caf9}%{F-}' ;;
        Transition) echo '%{F#ffb22e}󰖚%{F-}' ;;
        Night) echo '%{F#ff7575}󰖔%{F-}' ;;
        *) echo '%{F#f4f1d6}%{F-}' ;;
    esac
}

if [ -z "$(find_pid)" ]; then
  echo '%{F#96d952}%{T2}󰔎%{T-}%{F-}'
else
  echo "%{T2}$(read_period)%{T-}"
fi
