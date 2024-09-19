#!/bin/bash
# Load write_log function
source ./helpers/write_log.sh
# Function to increment IP address with validation checks
# Parameters:
#   1. IP address to be incremented
increment_ip() {
    local ip=$1
    # Validate IP format (simple check)
    if [[ ! $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Invalid IP address format: $ip" >&2
        return 1
    fi
    # Check if each part of the IP is within valid range (0-255)
    IFS='.' read -r -a octets <<< "$ip"
    for octet in "${octets[@]}"; do
        if ((octet < 0 || octet > 255)); then
            echo "Error: Invalid IP octet value in: $ip" >&2
            return 1
        fi
    done
    # Convert IP to integer
    local ipnum=$(echo "$ip" | awk -F. '{print ($1 * 256^3) + ($2 * 256^2) + ($3 * 256) + $4}')
    # Increment IP integer by 1
    ipnum=$((ipnum + 1))
    # Convert back to dotted IP format
    local new_ip=$(echo "$ipnum" | awk '{print int($1 / 256^3) "." int(($1 % 256^3) / 256^2) "." int(($1 % 256^2) / 256) "." ($1 % 256)}')
    # Ensure the new IP is valid (no overflow)
    if [[ ! $new_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: IP overflow occurred, invalid new IP: $new_ip" >&2
        exit 1  # Exit the entire script
    fi
    echo "$new_ip"
}
