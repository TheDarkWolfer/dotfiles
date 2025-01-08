#!/bin/bash

if [ -f /tmp/show_clock ]; then
    rm /tmp/show_clock
else
    touch /tmp/show_clock
fi

# Reload Waybar to apply the change
#killall waybar && waybar &
