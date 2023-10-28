#! /bin/env sh

function execute_if() {
    cmd=$1
    args=$2

    if command -v "$cmd" &> /dev/null
    then
        $cmd $args & 
    fi
}

execute_if telegram-desktop
execute_if thunderbird
execute_if steam
