#!/bin/sh

rofi() {
    i3-msg -t get_tree | jq -r \
        'recurse(.nodes[]) | select(.name == "__i3_scratch") | .floating_nodes[].nodes[] | 
        .window_properties.class + " — " + .name + "\u0000" +
        "icon\u001fwindow_list\u001f" +
        "info\u001f" + (.window | tostring)'
}

check() {
    count=$(i3-msg -t get_tree | jq -r \
        'recurse(.nodes[]) | select(.name == "__i3_scratch") | .floating_nodes[].nodes[].id' | wc -l)

    if [ "$count" -gt 0 ]; then
        echo "$count"
    else
        echo ""
    fi
}

if [ "$ROFI_RETV" = "1" ]; then
    i3-msg "[id=$ROFI_INFO] scratchpad show" > /dev/null
elif [ "$1" = "rofi" ]; then
    rofi
else
    check
fi
