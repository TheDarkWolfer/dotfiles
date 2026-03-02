#!/usr/bin/env bash

FLAG="/tmp/showDate"

case "$1" in
  -t|--toggle)
    if [[ -f "$FLAG" ]]; then
      rm "$FLAG"
    else
      touch "$FLAG"
    fi
  ;; 
  -tt|--toggle-temp)
    bash -c "$0 -t"
    sleep 3
    bash -c "$0 -t"
    ;;
  -s|--show)
    touch "$FLAG"
    ;;
  -h|--hide)
    rm "$FLAG"
    ;;
  *)
    if ! [[ -f "$FLAG" ]]; then 
      echo "$(date +'%H:%M:%S')"
    else
      echo "𝓣𝓲𝓶𝓮  𝓲𝓼  𝓪𝓷  𝓲𝓵𝓵𝓾𝓼𝓲𝓸𝓷"
    fi
  ;;
esac

