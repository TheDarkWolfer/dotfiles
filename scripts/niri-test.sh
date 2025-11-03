#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  #notify-send "Error" "No command provided." -u critical &
  exit 1
fi

case "$1" in 
  -e|--edit)
    nvim "$0"
    exit 0
    ;;
esac

#notify-send "i" "Opening $1"

CMD="$1"
IS_PROBLEM_CHILD=false

PROBLEM_APPS=("vintagestory" "lutris" "steam" "timeshift-launcher","lxappearance","torbrowser-launcher","monero-wallet-gui","aseprite","gparted")

for bad_app in "${PROBLEM_APPS[@]}"; do
  if [[ "$CMD" == *"$bad_app"* ]]; then
    IS_PROBLEM_CHILD=true
    break
  fi
done

if [[ "$IS_PROBLEM_CHILD" == true ]]; then
  #if pgrep -x niri > /dev/null; then
  #notify-send "i" "Started $1 with DISPLAY=:1" -u normal &
  (env DISPLAY=:1 "$@") &
  disown
  exit 0
  #else
  #  notify-send "i" "Niri not running, skipping..." -u normal
  #  exit 1
  #fi
else
  #notify-send "i" "Running normally..." -u low &
  (bash -c "$*" > /dev/null 2>&1) &
  disown
  exit 0
fi
