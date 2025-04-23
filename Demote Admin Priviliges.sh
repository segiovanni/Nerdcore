#!/bin/bash

# Exit on any error
set -e

# Log file for tracking changes
LOG_FILE="/var/log/admin_demotion.log"
echo "$(date): Starting admin demotion process" >> "$LOG_FILE"

# Get admin user list into an array for safer handling
read -r -a adminUsers < <(dscl . -read Groups/admin GroupMembership 2>/dev/null | awk '{print substr($0, index($0, $2))}')

# Check if adminUsers is empty
if [ ${#adminUsers[@]} -eq 0 ]; then
    echo "$(date): No admin users found or error retrieving list" >> "$LOG_FILE"
    exit 1
fi

echo "$(date): Admins found: ${adminUsers[*]}" >> "$LOG_FILE"

# Define approved admins
APPROVED_ADMINS=("root" "jamfadmin" "administrator")

# Demote all admins except approved ones
for user in "${adminUsers[@]}"; do
    # Check if user is in APPROVED_ADMINS
    skip_user=false
    for approved in "${APPROVED_ADMINS[@]}"; do
        if [ "$user" = "$approved" ]; then
            skip_user=true
            break
        fi
    done

    if [ "$skip_user" = true ]; then
        echo "$(date): Admin user $user left alone" >> "$LOG_FILE"
    else
        echo "$(date): Attempting to remove $user from admin group" >> "$LOG_FILE"
        if sudo dseditgroup -o edit -d "$user" -t user admin 2>/dev/null; then
            echo "$(date): Successfully removed $user from admin group" >> "$LOG_FILE"
        else
            echo "$(date): Failed to remove $user from admin group" >> "$LOG_FILE"
            # Continue despite failure; adjust as needed
        fi
    fi
done

echo "$(date): Admin demotion process completed" >> "$LOG_FILE"
exit 0