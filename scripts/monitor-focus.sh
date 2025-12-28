#!/usr/bin/env bash

MONITORS="$(niri msg --json outputs | jq '.[].name' | sed 's/\"//g')"
TARGET="$(echo -e "$MONITORS" | rofi -dmenu -p "Focus monitor")"

niri msg action focus-monitor $TARGET
