#!/bin/bash

sq="██"

GREEN="#8ccf7e"
YELLOW="#e5c76b"
RED="#e57474"
BLACK="#141b1e"

IS_VPN_RUNNING="$(systemctl is-active wg-quick@VPN)"
case "$IS_VPN_RUNNING" in
  "active") color1="$GREEN"
  ;;
  "inactive") color1="$RED"
  ;;
  *) color1="$YELLOW"
  ;;
esac

IS_TOR_RUNNING="$(systemctl is-active tor)"
case "$IS_TOR_RUNNING" in
  "active") color2="$GREEN"
  ;;
  "inactive") color2="$RED"
  ;;
  *) color2="$YELLOW"
  ;;
esac

# Counting root shells
count=$(ps -eo user,comm | awk '$1 == "root" && $2 ~ /bash|zsh|sh/' | grep -v "kworker" | wc -l)

case "$count" in 
  "0")
    color3="$GREEN"
    ;;
  "1")
    color3="$YELLOW"
    ;;
  "2"|"3")
    color3="$RED"
    ;;
  *)
    sec=$(date +'%S')
    if (( sec % 2 == 0 )) then
      color3="$RED"
    else
      color3="$BLACK"
    fi
esac

echo "<span color='#67b0e8'>[</span><span color='$color1'>$sq</span><span color='$color2'>$sq</span><span color='$color3'>$sq</span><span color='#67b0e8'>]</span><span color='#e5c76b'> </span>"
