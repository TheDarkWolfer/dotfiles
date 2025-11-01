#!/usr/bin/env bash

case "$1" in
  -t|--toggle)
    TOGGLE_FILE="/run/user/$(id -u)/mute-power-notifications"
    if [[ -f "$TOGGLE_FILE" ]]; then
      rm "$TOGGLE_FILE" && MUTE=false
      notify-send " " "Unmuted power notifications !" -u normal
    else
      touch "$TOGGLE_FILE" && MUTE=true
      notify-send " " "Muted power notifications !" -u normal
    fi
  ;;
esac


BATTERY="BAT0"

PSU_PATH="/sys/class/power_supply/$BATTERY"

STATUS="$(cat $PSU_PATH/status)"

# Current charge : energy_full / energy_now
ENERGY_FULL="$(cat $PSU_PATH/energy_full | tr -d '\n')"
ENERGY_NOW="$(cat $PSU_PATH/energy_now | tr -d '\n')"

CURRENT_CHARGE=$(( ($ENERGY_NOW * 100) / $ENERGY_FULL ))

if [[ "$MUTE" == "false" ]]; then
  if (( $CURRENT_CHARGE <= 40 )); then
    echo " "
    notify-send " " "Time to plug in the battery!" -u critical
  elif (( $CURRENT_CHARGE >= 80 && $CURRENT_CHARGE < 90 )); then
    echo " "
    notify-send " " "Consider unplugging soon..." -u low
  elif (( $CURRENT_CHARGE >= 90 )); then
    echo " "
    notify-send " " "Unplug the battery please!" -u critical
  elif (( $CURRENT_CHARGE >= 40 && $CURRENT_CHARGE <= 80)); then
    echo " "
  else 
  echo "I'm running but something went wrong x_x"
  notify-send "i" "I'm running but something went wrong x_x" -u critical
  fi
else 
  if (( $CURRENT_CHARGE <= 40 )); then
    echo " "
  elif (( $CURRENT_CHARGE >= 80 && $CURRENT_CHARGE < 90 )); then
    echo " "
  elif (( $CURRENT_CHARGE >= 90 )); then
    echo " "
  elif (( $CURRENT_CHARGE >= 40 && $CURRENT_CHARGE <= 80)); then
    echo " "
  else 
    notify-send "i" "I'm running but something went wrong x_x" -u critical
  fi
fi
