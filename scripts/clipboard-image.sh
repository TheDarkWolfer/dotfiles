#!/usr/bin/env bash

# Open snapshot utility on Niri
if pgrep -a -x niri >/dev/null && ! [[ "$(wl-paste --list-types)" == "image/png" ]] ; then
  niri msg action screenshot -p false
  while ! wl-paste --list-types 2>/dev/null | grep -qx 'image/png'; do
    sleep 0.1
  done
fi
case "$1" in 
  -qr|--qrcode)
    echo "starting QR code reading..."
    DATA="$(wl-paste --type image/png | zbarimg -qq - | sed 's/^QR-Code://')"
    echo "done reading QR code !"
    ;;
  -t|--text)
    echo "starting OCR on clipboard..."
    DATA="$(wl-paste --type image/png | tesseract - - -l eng+fra 2>/dev/null)"
    echo "done OCR on clipboard !"
    ;;
  *)
    exit 2
    ;;
esac 

if [[ -z "$DATA" ]]; then
  case "$1" in 
  -t|--text)
    echo "falling back to QR code reading..."
    DATA="$(wl-paste --type image/png | zbarimg -qq - | sed 's/^QR-Code://')"
    echo "done reading QR code !"
    ;;
  -qr|--qrcode)
    echo "falling back to OCR on clipboard..."
    DATA="$(wl-paste --type image/png | tesseract - - -l eng+fra 2>/dev/null)"
    echo "done OCR on clipboard !"
    ;;
  esac
fi

echo "copying result..."
wl-copy "$DATA"
echo "results copied !"
