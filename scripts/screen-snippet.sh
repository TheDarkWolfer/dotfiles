#!/usr/bin/env bash
niri msg action screenshot -p false
while ! wl-paste --list-types 2>/dev/null | grep -qx 'image/png'; do
  sleep 0.1
done
sxiv "$(find ~/Pictures/Screenshots -type f -name '*.png' -printf '%T@ %p\n' | sort -nr | head -n1 | cut -d' ' -f2-)"
echo "" | wl-copy
