#!/bin/sh

lastcount=-1

rofi() {
    i3-msg -t get_tree | jq -r \
        'recurse(.nodes[]) | select(.name == "__i3_scratch") | .floating_nodes[].nodes[] | 
        .window_properties.class + " — " + .name + "\u0000" +
        "icon\u001fwindow_list\u001f" +
        "info\u001f" + (.window | tostring)'
}

print_lastcount() {
    if [ "$lastcount" -gt 0 ]; then
        echo "$lastcount"
    else
        echo ""
    fi
}

count() {
    i3-msg -t get_tree | jq -r \
        'recurse(.nodes[]) | select(.name == "__i3_scratch") | .floating_nodes[].nodes[].id' | wc -l
}

subscribe() {
    lastcount=$(count)
    print_lastcount

    i3-msg -r -t subscribe -m '[ "window" ]' | while read -r x; do
        moved=$(echo "$x" | jq -r '(.change == "move")')

        if [ "$moved" = true ]; then
            newcount=$(count)
            [ "$newcount" -eq "$lastcount" ] && return
            lastcount=$newcount
            print_lastcount
        fi
    done
}

if [ "$ROFI_RETV" = "1" ]; then
    i3-msg "[id=$ROFI_INFO] scratchpad show" > /dev/null
elif [ "$1" = "rofi" ]; then
    rofi
else
    subscribe
fi
