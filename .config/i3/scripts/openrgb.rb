#! /bin/env ruby

system 'openrgb --noautoconnect -p RGB > /dev/null' if system 'command -v openrgb > /dev/null'
