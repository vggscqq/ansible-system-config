#!/bin/bash

while true
do
	sleep 1

	# Get the monitor configuration
	monitor_config=$(gnome-monitor-config list)

	# Check if Meta-0 is present and ON
	meta_0_on=$(echo "$monitor_config" | grep -q 'Monitor \[ Meta-0 \] ON' && echo "YES" || echo "NO")

	# Check if there is at least one other monitor ON
	other_monitors_on=$(echo "$monitor_config" | grep -v 'Monitor \[ Meta-0 \]' | grep 'Monitor \[.*\] ON' | wc -l)

	# Echo YES if Meta-0 is ON and there is at least one other monitor ON
	if [[ "$meta_0_on" == "YES" && "$other_monitors_on" -gt 0 ]]; then
		echo "Active RDP session detected and local monitor is active."
		echo "Disabling local monitors"
		GUI_SESSION=$(for session in $(loginctl list-sessions | awk 'NR>1 {print $1}'); do if loginctl show-session $session -p Type 2>/dev/null | grep -q 'Type=wayland'; then echo $session; fi; done)
		echo GUI session ID: $GUI_SESSION

		MetaRes=$(gnome-monitor-config list | grep -A 2 'Monitor \[ Meta-0 \]' | awk '/CURRENT/ {gsub(/[\[\]'\'' ]/, "", $3); print $3}')
		echo RDP monitor resolution: $MetaRes

		echo Disabling all the monitors but RDP
		gnome-monitor-config set -LpM Meta-0 -t normal -m $MetaRes > /dev/null 2>&1

		echo Lock session
		loginctl lock-session $GUI_SESSION
		echo Wait 2 sec
		sleep 2
		echo Unlock session
		loginctl unlock-session $GUI_SESSION
	fi

	if [[ "$meta_0_on" == "YES" && "$other_monitors_on" -eq 0 ]]; then
		echo "Active RDP session detected. No local monitor is active. Exiting..."
		continue
	fi

	if [[ "$meta_0_on" == "NO" ]]; then
		echo "No RDP sessions is active."
		echo "Locking local session"
	        GUI_SESSION=$(for session in $(loginctl list-sessions | awk 'NR>1 {print $1}'); do if loginctl show-session $session -p Type 2>/dev/null | grep -q 'Type=wayland'; then echo $session; fi; done)
		loginctl lock-session $GUI_SESSION
		echo "Locked session. Exiting..."
		continue
	fi
done
#GUI_SESSION=$(for session in $(loginctl list-sessions | awk 'NR>1 {print $1}'); do if loginctl show-session $session -p Type 2>/dev/null | grep -q 'Type=x11\|Type=wayland'; then echo $session; fi; done)
#echo GUI session ID: $GUI_SESSION

#MetaRes=$(gnome-monitor-config list | grep -A 2 'Monitor \[ Meta-0 \]' | awk '/CURRENT/ {gsub(/[\[\]'\'' ]/, "", $3); print $3}')
#echo RDP monitor resolution: $MetaRes

#echo Disabling all the monitors but RDP
#gnome-monitor-config set -LpM Meta-0 -t normal -m $MetaRes > /dev/null 2>&1

#echo Lock session
#loginctl lock-session $GUI_SESSION
#echo Wait 2 sec
#sleep 2
#echo Unlock session
#loginctl unlock-session $GUI_SESSION

