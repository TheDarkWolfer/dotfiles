#!/usr/bin/env bash
notify-send "Result:" "$(rofi -dmenu -p '󰃬 ' | sed 's/x/*/g; s/:/\//g' | bc)"
