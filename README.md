# Dotfile repository - Camille

### What is it ?
This is a repository that holds all the files necessary to recreate the config I use daily on EndeavorOS. On top of the scripts that I made and use daily, it contains dotfiles for :
- BTOP
- Dunst
- Hyprland
- Kando
- Kitty
- Waybar

### What to do ?
You can clone this repository with git :
``` 
git clone https://github.com/TheDarkWolfer/dotfiles 
```
and put all the folders inside your .config folder. You'll probably have to remap some of the paths for the scripts, as they are mapped for my device, and chances are you're not named camille and don't have the .scripts folder in your home directory. If you know of a way to streamline this and make the configs' paths change seamlessly between users, please let me know.

### What are the scripts ?
- battery.sh
    - Displays the current charge of your device in different formats.
    - battery-display-fix.sh is just a band-aid fix to display multiple outputs instead of one
    - args :    -s / --state    : for whether it is charging or discharging
                -e / --emoji    : to get an emoji representing the status
                -c / --charge   : to only get the charge percentage of the battery
                -b / --bar      : displays the charge as a bar. Can be customised in the script

- clock/date-toggle.sh
    - Toggles the display of certain elements of the waybar by creating/removing files in /tmp/

- favorites/menu/powermenu
    - rofi menus to access different applications quickly
    - menu has option to open the two others
    - their respective .rofi files' location must be specified in the code

- reset/rotate-touchscreen.sh
    - Used to rotate the view on your device. Necessary for mine (GPD Pocket 3), as other options felt too sensitive.

- usb-menu.sh
    - menu to control which USB devices can access your computer (or be accessed by your computer) using usbguard. Careful when installing that one, it's finnicky.