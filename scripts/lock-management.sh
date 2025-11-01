#!/bin/bash

OFF_FLAG="/run/user/$(id -u)/shutdown-trap.lock"
CAM_FLAG="/run/user/$(id -u)/camera-trap.lock"

case "$1" in
  -t|--trap)
  notify-send "i" "Setting up lock camera trap..." -u low
  sleep .5
  touch "$CAM_FLAG" 
  pidof hyprlock && exit -1
  env DISPLAY=:1 hyprlock -c ~/.config/scripts/hyprlock.conf && ( lock-trap.sh )
  ;;
  -s|--shutdown)
  notify-send "i" "Setting up lock shutdown trap..." -u low
  sleep .5
  touch "$OFF_FLAG" 
  pidof hyprlock && exit -1
  env DISPLAY=:1 hyprlock -c ~/.config/scripts/hyprlock.conf && ( lock-trap.sh )
  ;; *)
    [[ -f "$FLAG" ]] && rm "$FLAG"
    pidof hyprlock && exit -1
    hyprlock -c ~/.config/scripts/hyprlock.conf
  ;;
esac

unset $FLAG
