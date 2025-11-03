#!/bin/bash

killall mpd
mkdir -p ~/.config/mpd/playlists
  
mpd ~/.config/mpd/mpd.conf --no-daemon >> ~/.config/mpd/log 2>&1 &
#rmpc pause
disown
