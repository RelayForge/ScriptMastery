#!/bin/bash

# Function to write log messages with beautifications
# Parameters:
#   1. Log level (info, success, warning, error)
#   2. The message to be logged
#   3. Optional: log file path
write_log() {
    local log_level=$1
    local message=$2
    local log_file=$3
    
    # Define color codes
    local white='\033[1;37m'
    local green='\033[1;32m'
    local yellow='\033[1;33m'
    local red='\033[1;31m'
    local reset='\033[0m'

    # Choose color and label based on log level
    case "$log_level" in
        info)
            echo -e "${white}[INFO]${reset} $message"
            ;;
        success)
            echo -e "${green}[SUCCESS]${reset} $message"
            ;;
        warning)
            echo -e "${yellow}[WARNING]${reset} $message"
            ;;
        error)
            echo -e "${red}[ERROR]${reset} $message"
            ;;
        *)
            echo -e "[LOG] $message"  # Default log output
            ;;
    esac

    # Optionally log to file if log_file is provided
    if [ -n "$log_file" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$log_level] $message" >> "$log_file"
    fi
}
