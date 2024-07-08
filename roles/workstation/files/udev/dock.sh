#!/bin/bash

/usr/bin/powerprofilesctl set performance

if [ "$1" = "work" ]; then

	YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 166:1 166:0 # pause
	YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 113:1 113:0 # mute

	killall spotify

	XDG_RUNTIME_DIR="/run/user/1000" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus DISPLAY=:0 aplay /home/vgscq/.config/bin/udev/1-min-silence.wav &

	sleep 2

	#### mute ####
	YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 114:1 # mute
	sleep 5
	YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 114:0 # mute
	sleep 1
	YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 114:1 # mute
	sleep 5 
	YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 114:0 # mute
fi
