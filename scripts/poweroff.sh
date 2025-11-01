#!/usr/bin/env bash

LOCK_FILE="/run/$(id -u)/poweroff.lock"

if [[ -f "$LOCK_FILE" ]]; then
  (killall $0 && notify-send "󰐥 ")
else
  notify-send "󰐥 " "Powering off in 15s..."
  (sleep 15 && systemctl poweroff) &
  disown
fi
