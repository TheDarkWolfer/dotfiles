#!/usr/bin/env bash
set -euo pipefail

OFF='{"text":"Off","class":"off","alt":"off"}'
ON='{"text":"On","class":"on","alt":"on"}'

#You can check via /sys/class/leds/input*/capslock/brightness:

if [[ "$(cat /sys/class/leds/input*::capslock/brightness | head -n 1)" == "1" ]]; then
  echo "$ON"
else
  echo "$OFF"
fi
