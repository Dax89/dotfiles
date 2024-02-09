#!/bin/bash

if [ "$1" != "rofi" ]; then
    rofi -show "App Mixer"  \
         -modi "App Mixer:$0 rofi" \
         -kb-custom-16 "Ctrl+equal" \
         -kb-custom-17 "Alt+m" \
         -kb-custom-18 "minus,underscore" \
         -kb-custom-19 "equal,plus" \

    exit 0
fi

get_icon() {
    icon=$(grep -Ri "^Icon=$1\$" /usr/share/applications/*.desktop | awk -F '=' '{print $2}')
    [ -z "$icon" ] && icon="<span color='white' face='Symbols Nerd Font Mono'>󰓃</span>"
    echo "$icon"
}

list_clients() {
    pactl list sink-inputs | grep -E 'Sink Input #|application.name = "|application.process.binary = "|media.name|Volume|Mute'
}

change_volume() {
    pactl set-sink-input-mute "$ROFI_INFO" 0
    pactl set-sink-input-volume "$ROFI_INFO" "$1"
}

case "$ROFI_RETV" in
    25) pactl set-sink-input-volume "$ROFI_INFO" "100%" ;;
    26) pactl set-sink-input-mute "$ROFI_INFO" "toggle" ;;
    27) change_volume "-1%" ;;
    28) change_volume "+1%" ;;
    *) ;;
esac

list_clients | while read -r sink && \
                     read -r mute && \
                     read -r volume && \
                     read -r appname && 
                     read -r appbinary && 
                     read -r title; do
    volume=$(echo "$volume" | awk -F '/' '{
        left = int($2)
        right = int($4)
        if(left > right) printf "%03d", left
        else printf "%03d", right
    }')

    mute=$(echo "$mute" | awk -F ':' '{print $2}' | xargs)
    appname=$(echo "$appname" | awk -F '=' '{print $2}' | xargs)
    appbinary=$(echo "$appbinary" | awk -F '=' '{print $2}' | xargs)

    # Detect 'wine' process
    case "$appbinary" in
        wine*-preloader) appbinary="wine" ;;
        *) ;;
    esac

    # Strip '.exe' extension
    case "$appname" in
        *.exe) appname=${appname%.*} ;;
        *) ;;
    esac

    title=$(echo "$title" | awk -F '=' '{print $2}' | xargs)
    sink=$(echo "$sink" | awk -F '#' '{print $2}')

    if [ "$mute" = "yes" ]; then
        printf "MUTE — "
    else
        printf "%s%% — " "$volume"
    fi

    printf "%s | %s\0" "$appname" "$title"
    printf "icon\x1f%s\x1f" "$(get_icon "$appbinary")"
    printf "info\x1f%s\n" "$sink"
done

printf "\0use-hot-keys\x1ftrue\n"
printf "\0keep-selection\x1ftrue"

