#!/bin/sh

temp=$(sensors | awk '/(Tctl|Package id 0)/{printf("%d", $2)}')
echo "${temp:-???}°C"
