#!/usr/bin/env bash

case "$1" in
  -t) 
    STATUS="$(playerctl status)"
    if [[ "$STATUS" == "Playing" || "$STATUS" == "Paused" ]]; then
      playerctl play-pause
    else
      rmpc togglepause
    fi
    ;;
  -n)
    playerctl next
    rmpc next
    ;;
  -p)
    playerctl previous
    rmpc prev
    ;;
  -o)
    kitty sh -c "rmpc -c ~/.config/rmpc/config.json" --title "𝓜𝓾𝓼𝓲𝓬 𝓹𝓵𝓪𝔂𝓮𝓻"
    ;;
  *)
    truncate() {
    local input=$(echo "$1" | xargs)
    local max=32
    if [ ${#input} -le $max ]; then
        echo "$input"
    else
        echo "${input:0:$((max - 3))}..."
    fi
}

PLAYERCTL_STATUS=$(playerctl status 2>/dev/null)

if [[ "$PLAYERCTL_STATUS" == "Playing" ]]; then
    ARTIST=$(playerctl metadata artist 2>/dev/null)
    TITLE=$(playerctl metadata title 2>/dev/null)
    LINE="$TITLE"
    truncate "$LINE"
else
    MPC_STATUS=$(mpc status 2>/dev/null | grep '\[playing\]')
    if [[ -n "$MPC_STATUS" ]]; then
      LINE=$(rmpc song | jq .metadata.title | sed 's/([^)]*)//g' | sed 's/[“”"]//g')  
      truncate "$LINE"
    else
        echo " "
    fi
fi

  ;;
esac
