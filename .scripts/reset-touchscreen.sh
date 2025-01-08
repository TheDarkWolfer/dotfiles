#!/bin/bash

# Set the transform value (e.g., 90 degrees)
TRANSFORM_VALUE="3"

# Path to your Hyprland config file
CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"



# Update the transform setting for the touch device
sed -i "s/^input:touchdevice:transform = .*/input:touchdevice:transform = $TRANSFORM_VALUE/" "$CONFIG_FILE"
sed -i "s/^input:tablet:transform = .*/input:tablet:transform = $TRANSFORM_VALUE/" "$CONFIG_FILE"

# Reload the Hyprland config
hyprctl reload

hyprctl keyword monitor DSI-1,1200x1920,0x1080,1.5,transform,3

killall hyprpaper ; sleep .1 ; hyprpaper &
