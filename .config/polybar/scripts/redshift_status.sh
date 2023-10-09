#! /bin/sh

if [ "$(pgrep -x redshift)" ]; then
    echo "%{F#f7768e}%{F-}"
else
    echo "%{F#f7768e}%{F-}"
fi
