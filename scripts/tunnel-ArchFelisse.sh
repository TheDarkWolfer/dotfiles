#!/usr/bin/env bash

PIDFILE="/tmp/tunnel.pid"
source ~/.config/scripts/.server

case "$1" in 
	-k|--kill)
		! [[ -f "$PIDFILE" ]] && { echo "PID File not found. Is the tunnel running ?" ; exit 1 ; }
		kill "$(cat "$PIDFILE")"
		rm "$PIDFILE"
		echo -e "Closed tunnel to home..."
		;;
	-s|--start)
		ssh -N -L 9090:localhost:9090 -L 9091:localhost:9000 $USER@$IP -p $PORT &
		echo "$!" > "$PIDFILE"
		echo -e "Tunnel home is up and running !"
		;;
	*)
		if [[ -f "$PIDFILE" ]] ; then
			kill "$(cat "$PIDFILE")"
			rm "$PIDFILE"
			#echo -e "Closed tunnel to home..."
		else
			ssh -o BatchMode=yes -N -L 9090:localhost:9090 -L 9091:localhost:9000 $USER@$IP -p $PORT -i $KEYFILE &
			echo "$!" > "$PIDFILE"
			#echo -e "Tunnel home is up and running !"
		fi 
		;;
esac
