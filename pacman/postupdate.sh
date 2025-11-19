#!/usr/bin/env bash

case "$1" in 
  -i|--install)
    echo -e "Installing pacman post update hook"
    if [[ "$UID" == 0 ]]; then
      cp ./postupdate.sh /usr/local/bin/postupdate.sh && echo -e "Installed post-update script !" || echo -e "Error when trying to install post-update script !"
      cp ./postupdate.hook /etc/pacman.d/hooks/postupdate.hook && echo -e "Installed pacman post-update hook !" || echo -e "Error when trying to install the pacman hook !"
    else
      echo -e "The script needs elevated permissions to run, wanna sudo ?"
      sudo $0 --install
      exit 0

  *)
  echo -e "Doing post update cleanup..."

  echo -e "Fixing vencord's \`chrome-sandbox\` permissions..."
  chmod 4755 /usr/lib/vesktop/chrome-sandbox
  chown root:root /usr/lib/vesktop/chrome-sandbox

  file="/usr/share/applications/signal-desktop.desktop"
  argument="--password-store=\"kwallet6\" --"

  if ! grep 'password-store' "$file"; then
    sed -i 's/--/--password-store=\"kwallet6\" --/' $file  
  fi

  echo "Post update cleanup done !"
  ;;
esac
