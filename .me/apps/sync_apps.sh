#!/bin/sh

BINPATH="$HOME"/.local/bin

download() {
    name="$1"
    printf ">> Downloading \e[0;31m%s\e[0m...\n" "$name"

    pkill -9 -x "$name"
    curl -LO "$2"
    chmod +x "$BINPATH/$name"
}

restart() {
    name="$1"; shift
    printf ">> Restarting \e[0;31m%s\e[0m...\n" "$name"
    pkill -9 -x "$name"
    $name "$@" > /dev/null &
    pgrep -a -x "$name"
}

error() {
    echo "$1"
    exit 2
}

GREENCLIP_VER="v4.2"

mkdir -p "$BINPATH"
cd "$BINPATH" || error "Cannot find '$BINPATH'"

download "greenclip" "https://github.com/erebe/greenclip/releases/download/$GREENCLIP_VER/greenclip"
restart "greenclip" "daemon"

cd - > /dev/null || error "cd back failed"

echo "Building apps..."
"$HOME"/.me/apps/build_apps.sh "$BINPATH"
