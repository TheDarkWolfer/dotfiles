#!/usr/bin/env bash

case "$1" in 
  -w|--waybar)
    if ! pgrep rotation.sh > /dev/null 2>&1; then
     echo '{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'
    else
      echo '{"text":"Connected","class":"connected","alt":"connected"}'
    fi
    ;;
  *)
    if ! pgrep rotation.sh > /dev/null 2>&1; then
      notify-send " " -u normal "Auto rotation"
      rotation.sh &
    else
      pgrep rotation.sh | xargs kill
      notify-send " " -u normal "Locked rotation"
    fi
    ;;
esac
