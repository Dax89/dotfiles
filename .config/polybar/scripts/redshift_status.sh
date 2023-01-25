#! /bin/sh

if [ "$(pgrep -x redshift)" ]; then
    echo "%{F#e06b74}%{F-}"
else
    echo "%{F#414c52}%{F-}"
fi
