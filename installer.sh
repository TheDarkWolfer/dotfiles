#!/usr/bin/env bash

case "$1" in
 -i|--install)
    echo "Backing up existing dotfiles"
    zip old-dotfiles.zip -r ~/.config/niri/ ~/.config/waybar/ ~/.config/dunst/ ~/.config/kitty/ ~/.config/rofi/ && echo "Old dotfiles can be found here in 'old-dotfiles.zip' !" || echo "Couldn't backup existing dotfiles, guess there wasn't any."

    echo "Cleaning up the directories..."
    rm ~/.config/rofi/*
    rm ~/.config/niri/*
    rm ~/.config/kitty/*
    rm ~/.config/dunst/*

    echo "Installing dotfiles..."
    git clone https://github.com/TheDarkWolfer/dotfiles ~/.config/
    echo "All done !"
    ;;
 -u|--uninstall)
    echo "Removing dotfiles NYI"
    ;;
esac
