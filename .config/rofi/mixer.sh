#!/bin/sh

sinkidx=-1
sourceidx=-1

print_entries() {
    entries=$1 selentry=$2 icon=$3 type=$4 index=$5
    eval "${type}idx"=$(("$(echo "$entries" | jq -r 'map(.name == "'"$selentry"'") | index(true)')" + index))

    echo "$entries" | jq -r '
        .[] |
        (.name == "'"$selentry"'") as $nonselectable | 
        (if .mute then 0 else [.volume[] | .value_percent[:-1] | tonumber] | max end) as $volume |
        "\(.description) - \($volume)%\u0000" +
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

    print_entries "$sinks" "$selsink" 'audio-volume-high-symbolic' 'sink' 0
    printf '%75s\0nonselectable\x1ftrue\n' | tr ' ' '-'
    print_entries "$sources" "$selsource" 'microphone-sensitivity-high-symbolic' 'source' "$nsinks"
    printf "\0active\x1f%d,%d" "$sinkidx" "$sourceidx"
}

if [ "$ROFI_RETV" -eq 1 ]; then
    echo "$ROFI_INFO" | jq -r '.name,.type,.id,.icon' | while read -r name &&
                                                              read -r type && 
                                                              read -r id &&
                                                              read -r icon; do
        pactl set-default-"$type" "$id"
        current=$(pactl get-default-"$type")

        if [ "$type" = 'sink' ]; then
            if [ "$id" = "$current" ]; then
                dunstify Output "$name" -i "$icon" -r 2000 -u low
            else
                dunstify Output 'Output change failed' -i "$icon" -r 2000 -u critical
            fi
        elif [ "$id" = "$current" ]; then
            dunstify Input "$name" -i "$icon" -r 2000 -u low
        else
            dunstify Input 'Input change failed' -i "$icon" -r 2000 -u critical
        fi
    done
fi

show_audio
