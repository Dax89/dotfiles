#!/bin/sh

trap 'running=0' INT

running=1

while [ $running -eq 1 ]; do
    python "$HOME/.me/scripts/impl/org.vifm.FileManager1.py"
    sleep 1
done
