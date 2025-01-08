#!/bin/bash

while true; do
    ID=$(usbguard list-devices | fzf --reverse | awk '{print $1}' | tr -d ":")

    STATE=$(usbguard list-devices | grep "$ID:" | awk '{print $2}')

    if [[ "$STATE" == "allow" ]]; then
        usbguard block-device $ID
    elif [[ "$STATE" == "block" ]]; then
        usbguard allow-device $ID
    else
        exit
    fi
done
#if [[ "$1" == "in" ]] ; then
#kitty --title "𝓚𝓲𝓽𝓽𝔂" sh -c "usbguard list-devices | fzf | awk '{print $1}' | tr -d ':' | xargs usbguard allow-device 2>/dev/null"
#elif [[ "$1" == "out" ]] ; then 
#kitty --title "𝓚𝓲𝓽𝓽𝔂" sh -c "usbguard list-devices | fzf | awk '{print $1}' | tr -d ':' | xargs usbguard block-device 2>/dev/null"
#fi
