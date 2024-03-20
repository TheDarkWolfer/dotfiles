#!/bin/sh

if [$UID != 0] then:
	echo "You don't have sufficient privileges to run this script !"
	echo "Please use 'sudo' or refer to your system admin for help"
else:
	echo "Sufficient permissions, proceeding..."
fi

echo "[i] preparing installation..."
apt update && apt upgrade && apt-get update && apt-get upgrade
apt install npm golang

echo "[+] installing btop.."
apt install btop

echo "[+] installing wego (make sure to provide a weather API key)..."
go install github.com/schachmat/wego@latest"

echo "[+] installing cutefetch..."
curl https://raw.githubusercontent.com/cybardev/cutefetch/main/cutefetch >> cutefetch.sh

echo "[+] installing cbonsai..."
apt install cbonsai

echo "[+] installing chalk-animation..."
npm install --global chalk-animation

echo "[+] installing exa (ls replacement)..."
apt install exa
