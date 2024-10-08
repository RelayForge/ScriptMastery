#!/bin/bash
# Load write_log function
source ./helpers/write_log.sh
# Function to route and execute the appropriate script with colored output
# Parameters:
#   1. Prefix for the script (e.g., install, setup, configure)
#   2. OS family
#   3. OS version
execution_router() {
    local package=$1
    local prefix=$2
    local os_family=$3
    local os_version=$4
    # Define color codes
    local white='\033[1;37m'
    local green='\033[1;32m'
    local red='\033[1;31m'
    local reset='\033[0m'
    # Format the OS family and version for script naming (e.g., ubuntu_2204)
    os_family_lower=$(echo "$os_family" | tr '[:upper:]' '[:lower:]')
    os_version_nodot=$(echo "$os_version" | tr -d '.')
    # Construct the script name based on the prefix, OS family, and version
    script_name="./$package/${prefix}_${os_family_lower}_${os_version_nodot}.sh"
    # Check if the script exists
    if [ -f "$script_name" ]; then
        write_log "info" "[${white}${script_name}${reset}] ${green}Executing $script_name...${reset}" "$package" "$log_file"
        # Make the script executable and run it, while prefixing the output
        chmod +x "$script_name"
        ./"$script_name" | while IFS= read -r line; do
            write_log "info" "[${white}${script_name}${reset}] ${green}$line${reset}" "$package" "$log_file"
        done
    else
        write_log "error" "[${white}${script_name}${reset}] ${red}Error: Script $script_name not found!${reset}" "$package" "$log_file"
        return 1
    fi
}
