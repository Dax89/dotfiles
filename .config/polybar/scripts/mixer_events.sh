#!/bin/sh

if [ -n "$1" ]; then
    case "$1" in
        change)
            pactl set-sink-volume @DEFAULT_SINK@ "$2"
            pactl set-sink-mute @DEFAULT_SINK@ false
            ;;

        toggle)
            pactl set-sink-mute @DEFAULT_SINK@ toggle
            ;;
    esac

    exit 0
fi

get_current_device() {
    pactl get-default-sink
}

get_current_sinks() {
    pactl -f json list sinks | jq -c 'INDEX(.name)'
}

device=$(get_current_device)
sinks=$(get_current_sinks)

is_muted() {
    echo "$sinks" | jq -r '."'"$device"'".mute'
}

is_bluetooth() {
    echo "$sinks" | jq -r '."'"$device"'".properties."device.bus" == "bluetooth"'
}

get_icon() {
    if [ "$(is_bluetooth)" = true ]; then
        if [ "$(is_muted)" = true ]; then
            echo '%{F#dfae68}%{T2}󰗿%{T-}%{F-}'
        else
            echo '%{F#6699cc}%{T2}󰗾%{T-}%{F-}'
        fi
    else
        if [ "$(is_muted)" = true ]; then
            echo '%{F#dfae68}%{T2}󰖁%{T-}%{F-}'
        else
            echo '%{F#6699cc}%{T2}󱄡%{T-}%{F-}'
        fi
    fi
}

get_volume() {
    current=$(echo "$sinks" | jq -c '."'"$device"'"')
    
    if [ "$current" = "null" ]; then
        echo "???"
    else
        echo "$(echo "$current" | jq '[.volume[].value_percent[:-1] | tonumber] | max')%"
    fi
}

get_name() {
    current=$(echo "$sinks" | jq -c '."'"$device"'"')
    
    if [ "$current" = "null" ]; then
        echo "???"
    else
        name=$(echo "$current" | jq -r '.properties."alsa.name" // .description')
        echo "%{T4}%{F#9ece6a}$name%{F-}%{T-}"
    fi
}

device_changed() {
    currdevice=$(get_current_device)
    [ "$device" = "$currdevice" ] && return

    device="$currdevice"
    sinks=$(get_current_sinks)

    echo " $(get_icon) $(get_volume) $(get_name) "
}

device_updated() {
    sinks=$(get_current_sinks)
    echo " $(get_icon) $(get_volume) $(get_name) "
}

REGEX="Event 'change' on \(server\|sink\) #[0-9]\+" 

pactl subscribe | grep --line-buffered "$REGEX" | while read -r line; do
    m=$(expr "$line" : "$REGEX")

    case "$m" in
        server) device_changed ;;
        sink) device_updated ;;
        *) echo "Unsupported case '$m'" ;;
    esac
done