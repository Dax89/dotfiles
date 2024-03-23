#!/bin/bash

if [ "$1" != "rofi" ]; then
    rofi -show "Mixer"  \
         -modi "Mixer:$0 rofi" \
         -kb-custom-17 "Alt+m" \
         -kb-custom-18 "minus,underscore" \
         -kb-custom-19 "equal,plus" \

    exit 0
fi

sinkidx=-1
sourceidx=-1

get_icon() {
    echo "<span color='white' face='Symbols Nerd Font Mono'>$1</span>"
}

get_theme_icon() {
    if [ "$1" = "source" ]; then
        echo "microphone-sensitivity-high-symbolic"
    else
        echo "audio-volume-high-symbolic"
    fi
}

print_entries() {
    entries=$1 selentry=$2 icon=$3 type=$4 index=$5
    eval "${type}idx"=$(($(echo "$entries" | jq -r 'map(.name == "'"$selentry"'") | index(true)') + index))

    echo "$entries" | jq -r '
        .[] |
        (.name == "'"$selentry"'") as $nonselectable | 
        (if .mute then "MUTE" else [.volume[] | .value_percent[:-1] | tonumber] | max + 1000 | tostring[1:] + "%" end) as $volume |
        "\($volume) — \(.description)\u0000" +
        "icon\u001f'"$icon"'\u001f" +
        "info\u001f\({type: "'"$type"'", icon: "'"$icon"'", id: .name, name: .description} | tojson)\u001f" +
        "nonselectable\u001f\($nonselectable)"
    '
}

show_audio() {
    sinks=$(pactl -f json list sinks)
    sources=$(pactl -f json list sources)
    selsink=$(pactl get-default-sink)
    selsource=$(pactl get-default-source)
    nsinks=$(echo "$sinks" | jq "length + 1")

    print_entries "$sinks" "$selsink" "$(get_icon "󰓃")" 'sink' 0
    printf '%75s\0nonselectable\x1ftrue\n' | tr ' ' '-'
    print_entries "$sources" "$selsource" "$(get_icon "󰍰")" 'source' "$nsinks"
    printf "\0active\x1f%d,%d\n" "$sinkidx" "$sourceidx"
    printf "\0use-hot-keys\x1ftrue\n"
    printf "\0keep-selection\x1ftrue"
}

switch_device() {
    echo "$ROFI_INFO" | jq -r '.name,.type,.id' | while read -r name &&
                                                        read -r type && 
                                                        read -r id; do
        pactl set-default-"$type" "$id"
        current=$(pactl get-default-"$type")
        themeicon=$(get_theme_icon "$type")

        if [ "$type" = 'sink' ]; then
            if [ "$id" = "$current" ]; then
                dunstify Output "$name" -i "$themeicon" -r 2000 -u low
            else
                dunstify Output 'Output change failed' -i "$icon" -r 2000 -u critical
            fi
        elif [ "$id" = "$current" ]; then
            dunstify Input "$name" -i "$themeicon" -r 2000 -u low
        else
            dunstify Input 'Input change failed' -i "$icon" -r 2000 -u critical
        fi
    done

    exit 0
}

toggle_device_mute() {
    echo "$ROFI_INFO" | jq -r '.type,.id' | while read -r type && 
                                                  read -r id; do
                                                 
        pactl set-"$type"-mute "$id" "toggle"
    done
}

change_device_volume() {
    echo "$ROFI_INFO" | jq -r '.type,.id' | while read -r type && 
                                                  read -r id; do 
        pactl set-"$type"-mute "$id" "0"
        pactl set-"$type"-volume "$id" "$1"
    done
}

case "$ROFI_RETV" in
    1)  switch_device ;;
    26) toggle_device_mute ;;
    27) change_device_volume "-5%" ;;
    28) change_device_volume "+5%" ;;
    *) ;;
esac

show_audio
