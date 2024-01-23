#!/bin/sh

if command -v openrgb > /dev/null; then
    openrgb --noautoconnect -p RGB > /dev/null
fi
