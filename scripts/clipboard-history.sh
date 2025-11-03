#!/usr/bin/env bash
cliphist list | rofi -dmenu -p "Clipboard  " | cliphist decode | wl-copy
