#!/bin/bash

# Loop forever, waiting for MPD to signal "player" events
mpc idleloop player | while read _; do
    # Grab the current song title/artist
    song=$(mpc current)
    # Send a desktop notification
    notify-send "Now playing" "$song"
done
