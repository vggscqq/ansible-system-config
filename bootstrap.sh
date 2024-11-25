#!/bin/bash

# Variables

GITHUB_USERNAME="vggscqq"
GITHUB_REPOSITORY="ansible-system-config"
GITHUB_API_URL="https://api.github.com/repos/${GITHUB_USERNAME}/${GITHUB_REPOSITORY}/contents/roles"
REPO_URL="https://github.com/${GITHUB_USERNAME}/${GITHUB_REPOSITORY}.git"

# Fetch directory content from GitHub API
response=$(curl -s $GITHUB_API_URL)

# Check if response is valid JSON
if echo "$response" | jq empty > /dev/null 2>&1; then
    # Parse and store folder names in an array
    ROLES=($(echo "$response" | jq -r '.[] | select(.type == "dir" and .name != "base") | .name'))
else
    echo "Error fetching data from GitHub. Please check the repository details and try again."
    exit 1
fi

# Function to display the available roles
function display_roles() {
    echo "List of roles available:"
    local index=1
    for role in "${ROLES[@]}"; do
        echo "$index. $role"
        ((index++))
    done
}

# Function to read user input and build the tags string
function get_selected_roles() {
    local selected_indexes=()
    read -p "Select roles by their numbers (separated by space): " -a selected_indexes

    # Convert the selected indexes to role names
    local tags=("base")  # Always start with "base" tag
    for index in "${selected_indexes[@]}"; do
        if [[ $index -ge 1 && $index -le ${#ROLES[@]} ]]; then
            tags+=("${ROLES[$((index - 1))]}")
        else
            echo "Invalid selection: $index"
        fi
    done

    # Join tags with commas for ansible-playbook command
    echo "${tags[*]}" | tr ' ' ','
}

# Main script logic
display_roles
tags=$(get_selected_roles)

if [ -z "$tags" ]; then
    echo "No valid roles selected. Exiting."
    exit 1
fi

ansible-playbook --connection=local ./local.yml --tags "$tags"
