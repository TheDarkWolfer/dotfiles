#!/usr/bin/env bash

#O.llama S.tatus F.ile
OSF="/run/user/$(id -u)/ollama_status"
# POtential icons : 󰄄󰫍󰫎󰚩󰄰󰄄

function toggle {
    OLLAMA_PID="$(pgrep -xf 'ollama serve')"
    if ! [[ -z "$OLLAMA_PID" ]]; then
      kill $OLLAMA_PID && rm "$OSF"
    else
      touch "$OSF"
      (ollama serve) &
      disown
      exit
    fi
}

function turn_on {
  OLLAMA_PID="$(pgrep -xf 'ollama serve')"
  if [[ -z "$OLLAMA_PID" ]]; then
    touch "$OSF"
    (ollama serve) &
    disown
  fi
}

function turn_off {
  OLLAMA_PID="$(pgrep -xf 'ollama serve')"
  if ! [[ -z "$OLLAMA_PID" ]]; then
    kill $OLLAMA_PID && rm "$OSF"
  fi
}

function server_status {
  OLLAMA_PID="$(pgrep -xf 'ollama serve')"
  if [[ -z "$OLLAMA_PID" ]]; then
    echo '{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'
  else 
    echo '{"text":"Connected","class":"connected","alt":"connected"}'
  fi
}

case "$1" in
  -s|--status)
    server_status
    ;;
  -t|--toggle)
    toggle
    ;;
  -c|--chat)
    turn_on
    MODELS=$(ollama list | tail -n +2 | awk '{print $1}')
    ollama run $(echo "$MODELS" | fzf) 2>/dev/null 
    ;;  
  *) echo default
  ;;
esac

