#!/usr/bin/env bash

CAM_FLAG="/run/user/$(id -u)/camera-trap.lock"
OFF_FLAG="/run/user/$(id -u)/shutdown-trap.lock"

case "$1" in 
  -d|--disarm)
    # Disarm the camera trap
    rm "$CAM_FLAG"
    rm "$OFF_FLAG"
    exit 0
esac

if ! [[ -f "$CAM_FLAG" || -f "$OFF_FLAG" ]]; then
  exit -1
fi

# Allow access to the camera if using USBGuard
usbguard allow-device $(usbguard list-devices | grep 'Camera' | awk '{print $1}' | tr -d ':')

DEVICE="/dev/video0"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
OUTPUT="$HOME/Pictures/Camera/trap_snapshot_$TIMESTAMP.jpg"

ffmpeg -f v4l2 -video_size 1280x720 -i "$DEVICE" -vf "drawtext=text='%{localtime}':fontcolor=white:fontsize=24:x=10:y=10" -frames:v 1 "$OUTPUT" -y

sleep 3

# Block access to the camera afterwards, for security reasons
usbguard block-device $(usbguard list-devices | grep 'Camera' | awk '{print $1}' | tr -d ':')

if [[ -f "$OFF_FLAG" ]]; then
  shutdown +0 
fi
