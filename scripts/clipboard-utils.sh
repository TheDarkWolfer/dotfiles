#!/usr/bin/env bash

if [[ -f "/tmp/tunnel.pid" ]] ; then
	TUNNEL_CHOICE="󰌸 Close tunnel to Arch-Félisse"
else
	TUNNEL_CHOICE="󰌷 Open tunnel to Arch-Félisse"
fi

choice=$(echo -e " Kaomojis\n$TUNNEL_CHOICE\n󰈊 Color Picker\n ANSI box\n Transfer Photos\n Download video\n Download audio\n󰆄 Ascii to binary\n󰆄 Binary to ascii\n USB Thief" | rofi -dmenu -p "Quick Actions")

# Old options I'm not using that much anymore
#  /* Box */

process_clipboard ()
{
  wl-paste -n | boxes -d "$1" | wl-copy -n
}

copy_photos() {
  # Where to take and store files
  SRC="/run/media/camille/CAMERA-SD/DCIM/105PHOTO"
  DST="$HOME/Pictures/Camera/DCIM"

  mkdir -p "$DST"

  TOTAL=$(find "$SRC" -type f | wc -l)
  if [ "$TOTAL" -eq 0 ]; then
    dunstify "Copying files..." "No files to transfer" -h int:value:0
    return 0
  fi

  COUNT=0
  id=$(dunstify "Copying files..." "Starting transfer" -h int:value:0 -p)

  # Avoid subshell so COUNT updates persist
  while IFS= read -r -d '' file; do
    cp -- "$file" "$DST"/
    COUNT=$((COUNT + 1))
    PERCENT=$((100 * COUNT / TOTAL))
    dunstify "Copying files..." "$COUNT / $TOTAL" -h int:value:"$PERCENT" -r "$id"
  done < <(find "$SRC" -type f -print0)

  dunstify "Copy complete!" "Transferred $COUNT files." -h int:value:100 -r "$id"

	DEVICE="/dev/$(lsblk | grep CAMERA-SD | awk '{print $1}')"
	umount "$DEVICE"
	
	dunstify "SD Card unmounted !"
}




case "$choice" in
	" Kaomojis")
		cat ~/kaomoji.md | grep -v '[#`\n]' | rofi -dmenu -p "Pick a kaomoji ^.^" -theme-str '#inputbar { enabled : false; } ' | wl-copy -n
		;;
	"$TUNNEL_CHOICE")
		~/.config/scripts/tunnel-ArchFelisse.sh
		;;
  " /* Box */")
    process_clipboard jstone
    ;;
  " ANSI box")
    process_clipboard ansi-rounded
    ;;
	"󰈊 Color Picker")
		hyprpicker -af hex
		;;
  " Transfer Photos")
    copy_photos
    ;;
  " Download video")
    ~/.config/scripts/downloader.sh "$(wl-paste)"
    ;;
  " Download audio")
    ~/.config/scripts/downloader.sh -a "$(wl-paste)"
    ;;
  "󰆄 Ascii to binary")
    wl-paste | xxd -b | cut -d' ' -f2-7 | tr -d '\n ' | wl-copy
    ;;
  "󰆄 Binary to ascii")
    #wl-paste | sed 's/.\{8\}/& /g' | xxd -r -b | wl-copy
    
    wl-paste | grep -oE '.{8}' | while read b; do printf "%b" "$(printf "\\x%02X" "$((2#$b))")"; done | wl-copy
    ;;
	" USB Thief")
		~/.config/scripts/yoinkotron.sh 
		;;
esac
