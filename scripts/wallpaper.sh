#!/bin/bash

# Pre-run check to ensure we don't run too many instances of the wallpaper chooser at once
if [[ -z $(pgrep wallpaper.sh) ]] ; then
  if [[ -z $(pgrep apod.sh) ]] ; then
    notify-send "Still downloading today's APOD, please wait a second !"
    exit -1
  fi
  exit -1
fi


# Variables for picture management
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SYMLINK_PATH="$WALLPAPER_DIR/wallpaper"
OVERVIEW_SYMLINK_PATH="$WALLPAPER_DIR/overview"

# Get full list of wallpapers
mapfile -t FILES < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname "*.gif" \) | sort)

# Create OPTIONS array for both manual and auto
OPTIONS=()
OPTIONS+=("RANDOM")
OPTIONS+=("Updated APOD")
for file in "${FILES[@]}"; do
    relpath="${file#$WALLPAPER_DIR/}"
    OPTIONS+=("$relpath")
done

case "$1" in
  -o|--overview)
    choice=$(printf '%s\n' "${OPTIONS[@]}" | rofi -dmenu -p "Wallpaper (overview):")
    if [[ "$choice" == "RANDOM" ]] ; then
      choice=$(printf '%s\n' "${OPTIONS[@]}" | shuf -n 1)
    fi
    for file in "${FILES[@]}"; do
        if [[ "${file#$WALLPAPER_DIR/}" == "$choice" ]]; then
            ln -sf "$file" "$OVERVIEW_SYMLINK_PATH"
            swaybg -i ~Pictures/Wallpapers/overview
            break
        fi
    done

    ;;
  -m|--manual)
    choice=$(printf '%s\n' "${OPTIONS[@]}" | rofi -dmenu -p "Wallpaper:")
    if [[ "$choice" == "RANDOM" ]] ; then
      choice=$(printf '%s\n' "${OPTIONS[@]}" | shuf -n 1)
    elif [[ "$choice" == "Updated APOD" ]]; then
      apod.sh -m
      wallpaper.sh -n
      exit 0
    fi
    ;;
  -a|--auto)
    choice=$(printf '%s\n' "${OPTIONS[@]}" | shuf -n 1)
    ;;
  -r|--reload)
    wal -c &
    wal -i "$SYMLINK_PATH" -n &
    swww img "$SYMLINK_PATH" --transition-type wipe --transition-angle 13 --transition-fps 120 &
    #pkill -SIGUSR2 waybar
    exit 0
    ;;
  -n|--nasa)
    rm "$SYMLINK_PATH"
    APOD_LOCATION="$(find "$WALLPAPER_DIR" -maxdepth 1 -type f -iname 'apod-*.jpg' | head -n 1)"
    ln -sf "$APOD_LOCATION" "$SYMLINK_PATH"
    wal -c &
    wal -i "$SYMLINK_PATH" -n &
    swww img "$SYMLINK_PATH" --transition-type wipe --transition-angle 13 --transition-fps 120 &
    exit 0 
    ;;
  -p|--reapply)
    #wal -c &
    #wal -i "$SYMLINK_PATH" -n &
    swww img "$SYMLINK_PATH" --transition-type none &
    exit 0
    ;;
  *) exit -1 ;;
esac


# Set the selected wallpaper
if [[ -n "$choice" ]]; then
  notify-send "Changing wallpaper to : $choice"

    for file in "${FILES[@]}"; do
        if [[ "${file#$WALLPAPER_DIR/}" == "$choice" ]]; then
            ln -sf "$file" "$SYMLINK_PATH"
            wal -c &
            wal -i "$SYMLINK_PATH" -n &
            swww img "$SYMLINK_PATH" --transition-type wipe --transition-angle 13 --transition-fps 120
            #pkill -SIGUSR2 waybar
            break
        fi
    done
fi

