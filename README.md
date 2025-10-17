# Dotfile repository - Camille

### What is it ?
This is a repository that holds all the files necessary to recreate the config I use daily on EndeavorOS. On top of the scripts that I made and use daily, it contains dotfiles for :
- BTOP
- Dunst
- Niri
- Kitty
- Waybar

### What to do ?
You can clone this repository with git :
```shell
git clone https://github.com/TheDarkWolfer/dotfiles ~/.config/
```
This will copy the whole structure into your local config folder. ***IT WILL OVERWRITE ANY EXISTING CONFIGURATION, KEEP THAT IN MIND***

<sup>Please note that those configs are known to work on Arch and Arch-based distros, so YMMV</sup>

### What are the scripts ?
- battery.sh
    - Displays the current charge of your device in different formats.
    - args :    -s / --state    : for whether it is charging or discharging
                -n / --numeric  : to get a flat integer representing the current charge
                -c / --charge   : same as -n but with a percent sign at the end
                -e / --emoji    : uses nerd font to display a small icon depending on the charge level and state
                -b / --bar      : a bar of characters representing charge. Can be changed inside the script
                -g / --gradient : same as -b but solid blocks
                -r / --remaining: the time until reaching 0%
