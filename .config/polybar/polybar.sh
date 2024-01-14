#!/bin/sh

pkill -x polybar

while pgrep -u "$(id -u)" -x polybar > /dev/null; do 
    sleep 1;
done

polybar&
