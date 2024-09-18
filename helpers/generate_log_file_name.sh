#!/bin/bash

# Function to generate log file name
# Parameters:
#   1. Product name (e.g., wire-guard)
generate_log_file_name() {
    local product_name=$1

    # Get the current date and time in the format DDMMYYHHMMSS
    local datetime=$(date '+%y%m%d%H%M%S')

    # Construct the log file name
    local log_file="../logs/${product_name}-${datetime}.log"

    # Create the logs directory if it doesn't exist
    mkdir -p "../logs"

    # Return the log file path
    echo "$log_file"
}