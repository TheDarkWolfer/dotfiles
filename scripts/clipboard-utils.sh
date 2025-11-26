#!/usr/bin/env bash

choice=$(echo -e " /* Box */\n ANSI box\n Transfer Photos\n Download video\n Download audio\n󰆄 Ascii to binary\n󰆄 Binary to ascii" | rofi -dmenu -p "Quick Actions")

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
}




case "$choice" in 
  " /* Box */")
    process_clipboard jstone
    ;;
  " ANSI box")
    process_clipboard ansi-rounded
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
esac
