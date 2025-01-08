#!/bin/bash
#Yeah I'm too lazy to implement it in battery.sh, so this'll do for now
echo -e "$(/home/camille/.scripts/battery.sh -e)$(/home/camille/.scripts/battery.sh -c)%"