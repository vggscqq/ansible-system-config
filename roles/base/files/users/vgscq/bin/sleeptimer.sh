#!/bin/bash

set -e

# Get the number of minutes to wait from the first argument
wait_time=$1

# Convert the wait time to seconds
time_in_seconds=$((wait_time * 60))


# Sleep for the specified number of seconds.
#sleep $time_in_seconds

clear
echo "Sleeping for $wait_time minutes"

yes | pv -SpeL1 -s $time_in_seconds > /dev/null # progress bar

sudo YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 166:1 166:0 # pause
sudo YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 113:1 113:0 # mute

sudo YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 125:1 56:1 # alt + win press
for i in {1..10}; do YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 106:1 106:0; sleep 0.2; done
sudo YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool key 125:0 56:0 # alt + win release

sleep 1

# Suspend the system
sudo systemctl suspend
