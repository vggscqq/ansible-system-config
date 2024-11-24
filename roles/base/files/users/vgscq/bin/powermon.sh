#!/bin/bash

output=$(powerprofilesctl get)

ryzenadj () {
	true
}

case "$output" in
  *"performance"*)
    ryzenadj --tctl-temp=90 --max-performance > /dev/null
    echo -n "[|||] "
    ;;
  *"balanced"*)
    ryzenadj --tctl-temp=70 --power-saving > /dev/null
    echo -n "[|| ] "
    ;;
  *"power-saver"*)
    ryzenadj --tctl-temp=50 --power-saving > /dev/null
    echo -n "[|  ] "
    ;;
  *)
    echo "Unknown power profile: $output"
    ;;
esac


sensors | awk '/Tctl:/ { sub(/\+/, "", $2); sub(/°C/, "", $2); printf "%.0f° / ", $2 }';
awk '/1/ { print "On" } /0/ { print "Off" }' /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode

#powerprofilesctl get | sed -z 's/\n/ /'; \
#	sensors | awk '/Tctl:/ { sub(/\+/, "", $2); sub(/°C/, "", $2); printf "%.0f / ", $2 }'; \
#	ryzenadj -i | awk -F'|' '/THM LIMIT CORE/ { gsub(/[^0-9.]*/, "", $3); printf "%d°C ", $3 }'; \
#	awk '/1/ { print "On" } /0/ { print "Off" }' /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
