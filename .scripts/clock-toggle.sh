#!/bin/bash

if [ -f /tmp/show_date ]; then
    rm /tmp/show_date
else
    touch /tmp/show_date
fi

# Reload Waybar to apply the change
#killall waybar && waybar &
