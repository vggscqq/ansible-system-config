#!/bin/bash

set -e

file_path="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"

# Read the current value from the file
value=$(cat "$file_path")

# Toggle the value
if [[ $value -eq 1 ]]; then
  new_value=0
else
  new_value=1
fi

# Write the new value back to the file
echo "$new_value" | sudo tee "$file_path"

echo "Value in $file_path has been toggled. New value: $new_value"

