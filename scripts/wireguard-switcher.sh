#!/bin/bash
SELECTION=$(echo -e "$(ls ~/Documents/Secrets/VPN/)" | rofi -dmenu -p "VPN" )
SOURCE_PATH="$HOME/Documents/Secrets/VPN/$SELECTION"
DEST_PATH="/etc/wireguard/VPN.conf"
VPN_SERVICE="wg-quick@VPN"
if [ -n "$SELECTION" ]; then
  SUDO_ASKPASS=~/.config/scripts/pass.sh sudo -A systemctl stop "$VPN_SERVICE"
  SUDO_ASKPASS=~/.config/scripts/pass.sh sudo -A rm "$DEST_PATH"
  SUDO_ASKPASS=~/.config/scripts/pass.sh sudo -A cp "$SOURCE_PATH" "$DEST_PATH"
  #SUDO_ASKPASS=~/.config/scripts/pass.sh sudo -A resolvconf -u
  sleep 1
  SUDO_ASKPASS=~/.config/scripts/pass.sh sudo -A systemctl start "$VPN_SERVICE"
  dunstify "Switched to ${SELECTION%.conf} !" -u "normal"
else
  dunstify "Error when trying to change VPN config..." -u "low"
fi
