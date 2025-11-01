#!/bin/bash
VPN=$(ifconfig | grep -E 'Spain|Germany|Paris')

VPN_TEMP="/tmp/isVPN_mem"

case "$1" in 
  -s|--status)
  CONNECTED_STR='{"text":"Connected","class":"connected","alt":"connected"}'
  DISCONNECTED_STR='{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'
  if [[ $(ifconfig | grep -E 'Spain|Germany|Paris') ]] ; then
    echo "$CONNECTED_STR"
  else
    echo "$DISCONNECTED_STR"
  fi
  ;;
  -t|--toggle)
    if [[ $(ifconfig | grep -E 'Spain|Germany|Paris') ]] ; then
      CONNECTION="$(ifconfig | grep -E 'Spain|Germany|Paris' | awk '{print $1}')"
      echo "$CONNECTION" >> "$VPN_TEMP"
      nmcli c down $CONNECTION
    else
      nmcli c up "$(cat $VPN_TEMP)"
    fi
    ;;
esac
