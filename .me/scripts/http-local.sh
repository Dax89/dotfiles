#!/bin/sh

trap 'running=0' INT

running=1

while [ $running -eq 1 ]; do
    cd "$HOME/.me/http" || exit 2
    python -m http.server 8080
    sleep 1
done
