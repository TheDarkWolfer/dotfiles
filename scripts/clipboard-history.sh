#!/usr/bin/env bash
selection="$(cliphist list | rofi -dmenu -p 'Clipboard  ')"

# If the user cancelled, do nothing.
[ -z "$selection" ] && exit 0

# Try to decode a real cliphist entry; if that fails, copy the raw input.
if decoded="$(cliphist decode <<<"$selection" 2>/dev/null)"; then
  printf '%s' "$decoded" | wl-copy
else
  printf '%s' "$selection" | wl-copy
fi
