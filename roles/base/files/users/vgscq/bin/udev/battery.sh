#!/bin/bash

if [ "$1" == "blink" ]; then
    while true; do
        echo 2 | tee /sys/class/leds/platform::kbd_backlight/brightness
        sleep 1
	echo 0 | tee /sys/class/leds/platform::kbd_backlight/brightness
	sleep 5
    done
#else
#    echo "Usage: $0 echo"
fi

if [ "$1" == "kill" ]; then
	killall battery.sh
	sleep 1
	echo 0 | tee /sys/class/leds/platform::kbd_backlight/brightness
fi
