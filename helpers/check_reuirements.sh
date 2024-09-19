#!/bin/bash
# Load write_log function
source ./helpers/write_log.sh
# Guard to prevent multiple sourcing
if [ -z "$CHECK_EXECUTION_LOADED" ]; then
    CHECK_EXECUTION_LOADED=1
    # Function to check if reuirements are available and install them if not
    check_reuirements() {
        if ! command -v yq &> /dev/null; then
            write_log "warning" "yq is not installed. Installing yq..." "reuirements" "$log_file"
            sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && \
            sudo chmod +x /usr/bin/yq
            if command -v yq &> /dev/null; then
                write_log "success" "yq successfully installed." "reuirements" "$log_file"
            else
                write_log "error" "yq installation failed." "reuirements" "$log_file"
                exit 1  # Return failure if installation fails
            fi
        else
            write_log "success" "yq is already installed." "reuirements" "$log_file"
        fi
    }
fi