#!/bin/bash
# Guard to prevent multiple sourcing
if [ -z "$WRITE_LOG_LOADED" ]; then
    WRITE_LOG_LOADED=1
    write_log() {
    # Function to write log messages with beautifications
    # Parameters:
    #   1. Log level (info, success, warning, error)
    #   2. The message to be logged
    #   3. Package name
    #   3. Log file path
        local log_level=$1
        local message=$2
        local package=$3
        local log_file=$4
        # Define color codes
        local white='\033[1;37m'
        local green='\033[1;32m'
        local yellow='\033[1;33m'
        local red='\033[1;31m'
        local reset='\033[0m'
        # Get the current date and time in the format YYMMDDHHMMSS
        local datetime=$(date '+%y%m%d')
        # Construct the log file name
        local log_file="./logs/${package}-${datetime}.log"
        # Create the logs directory if it doesn't exist
        mkdir -p "./logs"
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
        # Log to file
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$log_level] $message" >> "$log_file"
    }
fi