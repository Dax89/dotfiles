#!/bin/sh

temp=$(sensors -j | jq '(."k10temp-pci-00c3".Tctl.temp1_input // ."coretemp-isa-0000"."Package id 0".temp1_input) | round')
echo "${temp:-???}°C"
