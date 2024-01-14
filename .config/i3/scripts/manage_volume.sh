#!/bin/sh

VOLUME_APP="i3-volume"

get_current_sink() {
    sinks=$(pactl -f json list sinks)
    selsink=$(pactl get-default-sink)
    sink=$(echo "$sinks" | jq -c ".[] | select(.name == \"$selsink\")" )

    if [ -z "$sink" ]; then
        echo '<NO SINK>'
        return
    fi

    name=$(echo "$sink" | jq -r ".properties.\"alsa.name\"")
    [ -z "$name" ] && name=$(echo "$sink" | jq -r ".description")
    [ -z "$name" ] && name="<NO SINK>"
    echo "$name"
}

is_muted() {
    out=$(pactl get-sink-mute @DEFAULT_SINK@)

    case $out in
        *no) echo 0 ;;
        *yes) echo 1 ;;
    esac
}

notify_volume() {
    vol=$(read_volume)

    if [ "$vol" -lt 50 ]; then
        icon="audio-volume-low-symbolic"
    elif [ "$vol" -ge 50 ] && [ "$vol" -le 75 ]; then
        icon="audio-volume-medium-symbolic" 
    elif [ "$vol" -gt 75 ] && [ "$vol" -le 100 ]; then
        icon="audio-volume-high-symbolic"
    else
        icon="audio-volume-overamplified-symbolic"
    fi

    dunstify -a $VOLUME_APP -h int:value:"$vol" -i "$icon" -u low "$vol% [$(get_current_sink)]"
}

read_volume() {
    out=$(pactl get-sink-volume @DEFAULT_SINK@)
    left=$(echo "$out" | awk '/front-left/{print substr($5, 0, length($5)-1)}')
    right=$(echo "$out" | awk '/front-right/{print substr($5, 0, length($5)-1)}')
    echo $((left >= right ? left : right))
}

toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle

    if [ "$(is_muted)" -eq 1 ]; then
        dunstify -a "$VOLUME_APP" -i audio-volume-muted-symbolic -u low "OFF [$(get_current_sink)]"
    else
        notify_volume
    fi
}

write_volume()  {
    [ "$(is_muted)" -eq 1 ] && toggle_mute
    pactl set-sink-volume @DEFAULT_SINK@ "$1"
    notify_volume
}

case $1 in
    "set-volume")
        if [ "$#" -ne 2 ]; then
            echo "Missing volume level"
            exit 1
        fi

        write_volume "$2"
        ;;

    "toggle-mute")
        toggle_mute
        ;;

    *)
        echo "Invalid command '$1'"
        exit 1
        ;;
esac
