#!/bin/sh

mode="full"
clipboard=0
filepath=""

usage() {
    echo "Options:
  -m  Screenshot mode (full, active, selection)
  -c  Copy image to Clipboard"

    exit 2
}

gen_filename() {
    time=$(date +'%d%m%Y_%H%M%S')
    echo "Screenshot_$time.png"
}

grab_active_window() {
    activewin=$(xprop -root | awk -F '#' '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $2}')
    printf "%d\n" "$activewin" # Hex string to decimal number
}

clipboard_copy() {
    echo "file://$1" | xclip -selection clipboard -t text/uri-list
}

notify() {
    dunstify -a 'Screenshot' "$1" -i accessories-screenshot
}

while getopts "m:c" opt; do
    case "$opt" in
        m) mode="$OPTARG" ;;
        c) clipboard=1 ;;
        *) usage ;;
    esac
done

if [ "$clipboard" -eq 1 ]; then
    filepath="/tmp/screenshot.png"
else
    filepath="$HOME/$(gen_filename)"
fi

case "$mode" in
    active) maim -u --window "$(grab_active_window)" "$filepath" ;;
    selection) maim -u --select "$filepath" ;;
    full) maim -u "$filepath" ;;
    *) echo "Mode '$mode' is not valid" exit 1 ;;
esac

code="$?"

if [ "$code" -ne 0 ]; then
    notify 'Screenshot cancelled'
    exit 0
fi

if [ "$clipboard" -ne 0 ]; then
    clipboard_copy "$filepath"
    notify 'Copied to clipboard'
else
    notify 'Saved'
fi
