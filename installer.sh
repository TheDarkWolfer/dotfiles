#!/usr/bin/env bash

case "$1" in
 -i|--install)
    echo "Installing dotfiles..."
    ;;
 -u|--uninstall)
    echo "Removing dotfiles..."
    ;;
 *)
    echo "Something went wrong somewhere"
    ;;
esac