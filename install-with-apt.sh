#!/bin/sh

if [$UID != 0] then:
	echo "You don't have sufficient privileges to run this script !"
	echo "Please use 'sudo' or refer to your system admin for help"
else:
	echo "Sufficient permissions, proceeding..."
fi

echo "[i] preparing installation..."
apt update -y && apt upgrade -y && apt-get update -y && apt-get upgrade-y 
apt -y install npm golang

echo "[+] installing btop.."
apt -y install btop

echo "[+] installing wego (make sure to provide a weather API key)..."
go install github.com/schachmat/wego@latest"

echo "[+] installing cutefetch..."
curl https://raw.githubusercontent.com/cybardev/cutefetch/main/cutefetch >> cutefetch.sh

echo "[+] installing cbonsai..."
apt -y install cbonsai

echo "[+] installing chalk-animation..."
npm install --global chalk-animation

echo "[+] installing exa (ls replacement)..."
apt -y install exa

echo "[+] installing alacritty..."
apt -y install alacritty
cp ./alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

echo "[+] installing polybar..."
apt -y install polybar
cp ./polybar/conf ~/.config/polybar/conf

echo "[+] installing feh (for wallpapers)..."
apt -y install feh

echo "[+] installing tty-clock..."
apt -y install tty-clock

echo "[+] installing/updating python v3"
apt -y install python3

echo "[+] installing thefuck (shell corrector)"
pip3 install thefuck

echo "[+] copying config files..."
cp ./i3/* ~/.config/i3/
cp ./i3blocks/* ~/.config/i3blocks/
cp ./i3status/* ~/.config/i3status/
mkdir ~/.config/scripts
cp ./scripts/* ~/.config/scripts/
cp ~/flex.py ~/.config/scripts/flex.py
