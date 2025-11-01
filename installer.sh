#!/usr/bin/env bash

case "$1" in
 -i|--install)
    echo "Backing up existing dotfiles"
    zip old-dotfiles.zip -r ~/.config/rmpc/ ~/.config/qutebrowser/ ~/.config/niri/ ~/.config/waybar/ ~/.config/dunst/ ~/.config/kitty/ ~/.config/rofi/ && echo "Old dotfiles can be found here in 'old-dotfiles.zip' !" || echo "Couldn't backup existing dotfiles, guess there wasn't any."

    # URLs for some remote themes
    KITTY_REMOTE_THEME="https://raw.githubusercontent.com/rose-pine/kitty/refs/heads/main/dist/rose-pine.conf"
    ROFI_REMOTE_THEME="https://raw.githubusercontent.com/rose-pine/rofi/refs/heads/main/rose-pine.rasi"

    echo "Cleaning up the directories..."
    rm ~/.config/rofi/*
    rm ~/.config/niri/*
    rm ~/.config/kitty/*
    rm ~/.config/dunst/*

    mkdir -p ~/.config/scripts

    # Symlink dunstrc
    ln -s ~/.config/dunst/dunstrc ./dunst/dunstrc

    # Symlink kitty conf & download rosepine color theme
    ln -s ~/.config/kitty/kitty.conf ./kitty/kitty.conf
    wget "$KITTY_REMOTE_THEME" -o ~/.config/kitty/rose-pine.conf

    # Symlink cava config
    ln -s ~/.config/cava/config ./cava/config

    # Symlink niri config
    ln -s ~/.config/niri/config.kdl ./niri/config.kdl

    # Symlink qutebrowser config
    ln -s ~/.config/qutebrowser/config.py ./qutebrowser/config.py

    # Symlink rmpc config & theme
    ln -s ~/.config/rmpc/config.json ./rmpc/config.json
    ln -s ~/.config/rmpc/rose-pine.ron ./rmpc/rose-pine.ron #<- Will change if rosepine implements a rmpc theme

    # Symlink rofi theme & download rosepine color theme 
    ln -s ~/.config/rofi/config.rasi ./rofi/config.rasi
    wget "$ROFI_REMOTE_THEME" -o ~/.config/rofi/rose-pine.rasi

    # Symlink waybar config & style
    ln -s ~/.config/waybar/config ./waybar/config
    ln -s ~/.config/waybar/style.css ./waybar/style.css

    # Symlink all the fucking shell scripts I use x)
     

    ;;
 -u|--uninstall)
    echo "Removing dotfiles NYI"
    ;;
esac
