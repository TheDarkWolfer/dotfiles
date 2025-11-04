#!/bin/env bash

wf-recorder_check() {
	if pgrep -x "wf-recorder" > /dev/null; then
			pkill -INT -x wf-recorder
			notify-send "Stopping all instances of wf-recorder" "$(cat /tmp/recording.txt)"
			wl-copy < "$(cat /tmp/recording.txt)"
			exit 0
	fi
}


IMG="${HOME}/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png"
VID="${HOME}/Videos/Recordings/$(date +%Y-%m-%d_%H-%m-%s).mp4"

STATUS_ON='{"text":"On","class":"on","alt":"on"}'
STATUS_OFF_STR='{"text":"Off","class":"off","alt":"off"}'

case "$1" in 
  -s|--status)
    if pgrep -x "wf-recorder" > /dev/null; then
      echo "$STATUS_ON"
    else
      echo "$STATUS_OFF_STR"
    fi
    exit 0
  ;;
	-g|--grim)
		IMG="${HOME}/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png"
		grim -g "$(slurp)" "$IMG"
    wl-copy --type image/png < "$IMG"
		exit 0
	;;
#-e|--eye)
#  notify-send "Recording selection" "$VID"
#  echo "$VID" > /tmp/recording.txt
#  wf-recorder  -g "$(slurp)" -f "$VID" &>/dev/null
#  exit 0
#  ;;
esac

SELECTION=$(echo -e "screenshot selection\nscreenshot HDMI-A-1\nscreenshot eDP-1\nrecord selection\nrecord eDP-1\nrecord HDMI-A-1" | rofi -dmenu -p "󰄀 " -w 25 -l 6)

#AUDIO_SOURCE="$(pactl list short sources | grep bluez | awk '{print $2}' | tail -n 1)"
AUDIO_SOURCE="$(pactl list sources short | grep RUNNING | awk '{print $2}' | head -n 1)"
echo "AUDIO:$AUDIO_SOURCE"

wf-recorder_check

case "$SELECTION" in
	"screenshot selection")
		grim -g "$(slurp)" "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
		;;
  "screenshot HDMI-A-1")
		grim -c -o eDP-1 "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
    ;;
	"screenshot eDP-1")
		grim -c -o eDP-1 "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
		;;
  "record selection")
    notify-send "Recording selection" "$VID"
		echo "$VID" > /tmp/recording.txt
		wf-recorder  -g "$(slurp)" -f "$VID" -a "$AUDIO_SOURCE" &>/dev/null
		;;
	"record eDP-1")
    notify-send "Recording eDP-1" "$VID"
		echo "$VID" > /tmp/recording.txt
		wf-recorder  -o eDP-1 -f "$VID" -a "$AUDIO_SOURCE" &>/dev/null
    ;;

  "record HDMI-A-1")
    notify-send "Recording HDMI-A-1" "$VID"
    echo "$VID" > /tmp/recording.txt
  	wf-recorder  -o HDMI-A-1 -f "$VID" -a "$AUDIO_SOURCE" &>/dev/null
    ;;
*)
  exit -99
	;;
esac
