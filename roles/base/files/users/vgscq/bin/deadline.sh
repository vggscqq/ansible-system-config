#!/bin/bash

# Define deadlines
deadlines=(
    #"Zapis FP:27.06.2023"
    #"Visa:1.07.2023"
    #"Být:18.06.2023"
    #"Visa:29.06.2023"
    #"Payday:16.07.2023"
    #"Let:22.07.2023"
    #"Visa:16.8.2023"
    #"WF:27.08.2023"
    "ZP:10.12.2024"
    "NG:31.12.2024"
    #"WD:15.10.2023"
    #"Rozvrch:08.09.2023"
    #"DR:20.08.2023"
    #'len:27.09.2023'
)

# Get current date in Unix timestamp format
current_date=$(date +%s)

# Iterate through deadlines
for deadline in "${deadlines[@]}"; do
    # Split deadline into project and date
    IFS=":" read -r project raw_date <<< "$deadline"

    # Convert date format to YYYY-MM-DD
    formatted_date=$(echo "$raw_date" | awk -F'.' '{print $3"-"$2"-"$1}')

    # Convert deadline date to Unix timestamp
    deadline_date=$(date -d "$formatted_date" +%s)

    # Calculate remaining days
    remaining_days=$(( (deadline_date - current_date) / (60*60*24) ))

    # Output result
    echo -n "$project: $remaining_days"d"; "
done

echo

