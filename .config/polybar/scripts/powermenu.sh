#!/bin/sh

execute() {
    if command -v systemctl > /dev/null; then
        systemctl "$1"
    else
        loginctl "$1"
    fi
}

execute "$1"
