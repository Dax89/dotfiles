#! /bin/perl

if(system("command -v openrgb > /dev/null") == 0) {
    system("openrgb --noautoconnect -p RGB > /dev/null");
}

