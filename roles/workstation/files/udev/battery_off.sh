#!/bin/bash

killall battery.sh
sleep 1
echo 0 | tee /sys/class/leds/platform::kbd_backlight/brightness
