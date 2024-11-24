#!/bin/bash

echo "RUN" >> /tmp/udev.log

# Check if the system is connected to AC or battery using /sys/class/power_supply/ACAD/online
if [ -f /sys/class/power_supply/ACAD/online ]; then
    # AC is connected if /sys/class/power_supply/ACAD/online == 1
    power_status=$(cat /sys/class/power_supply/ACAD/online)
    if [ "$power_status" -eq 1 ]; then
        power_status="ac"
    else
        power_status="battery"
    fi
else
    power_status="battery"  # Default to battery if ACAD is not present
fi

# Check if dock is connected (based on vendor IDs or other dock detection method)
dock_status="none"
if lsusb | grep -q "0b95:1790"; then
    dock_status="work"  # Work dock connected
elif lsusb | grep -q "0bda:5487"; then
    dock_status="home"  # Home dock connected
fi

# Set power profile based on the dock status and power supply
if [ "$dock_status" = "work" ]; then  
    /usr/bin/powerprofilesctl set performance

    # Actions for work dock
    YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 166:1 166:0 # pause
    YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 113:1 113:0 # mute
    killall spotify
    XDG_RUNTIME_DIR="/run/user/1000" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus DISPLAY=:0 aplay /home/vgscq/.config/bin/udev/1-min-silence.wav &
    sleep 2

    # Mute toggling actions
    YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 114:1; sleep 5; ydotool key 114:0
    sleep 1
    YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 114:1; sleep 5; ydotool key 114:0

    echo "Connected to work dock. Profile set to performance."

elif [ "$dock_status" = "home" ]; then
    # Home dock actions
    /usr/bin/powerprofilesctl set performance
    echo "Connected to home dock. Profile set to performance."

elif [ "$power_status" = "ac" ]; then
    # AC power connected, set balanced profile
    /usr/bin/powerprofilesctl set balanced
    echo "Connected to power adapter. Profile set to balanced."
    
elif [ "$power_status" = "battery" ]; then
    # Running on battery, set power-saver profile
    /usr/bin/powerprofilesctl set power-saver
    echo "Running on battery. Profile set to power-saver."
fi
